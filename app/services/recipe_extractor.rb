require "open-uri"
require "nokogiri"
require "json"

class RecipeExtractor
  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  #
  # @param url [String, #to_s] The recipe source URL provided by the user.
  #
  # Strip all leading/trailing whitespace so that incidental spaces, tabs,
  # or new-line characters do not break `URI.parse/URI.open`. This guards
  # against `URI::InvalidURIError` raised when a user pastes a URL with
  # trailing whitespace (see Linear REC-8 / Sentry RECIPIN-4).
  #
  def initialize(url)
    @url = url.to_s.strip
  end

  # Extract structured data for the recipe while protecting callers from
  # unexpected runtime errors. If anything goes wrong we log the failure and
  # return an empty hash; callers already treat missing keys as "nothing to
  # update" so this is safe.
  def data
    {
      name:        string(:headline, :name),
      description: string(:description),
      servings:    string(:recipeYield),
      image_url:   image(:image, :thumbnailUrl),
      prep_time:   duration(:prepTime),
      cook_time:   duration(:cookTime),
      total_time:  duration(:totalTime),

      ingredients:,
      instruction_sections:,
    }
  rescue StandardError => e
    Rails.logger.error("[RecipeExtractor] Failed to extract data: #{e.class} – #{e.message} (URL: #{@url.inspect})")
    {}
  end
  end

  private

  def string(*keys)
    SchemaExtractor::Base.new(schema, keys).extract
  end

  def image(*keys)
    SchemaExtractor::Image.new(schema, keys).extract
  end

  def duration(*keys)
    SchemaExtractor::Duration.new(schema, keys).extract
  end

  def ingredients
    SchemaExtractor::Ingredients.new(schema, :recipeIngredient).extract
  end

  def instruction_sections
    SchemaExtractor::InstructionSections.new(schema, :recipeInstructions).extract
  end
 
  def doc
    @doc ||= Nokogiri::HTML(fetch_source)
  end

  def raw_json
    @raw_json ||= ld_json_chunks.find { it.include?("Recipe") }
  end

  def schema
    @schema ||= (schemas[:recipe] || schemas[:article] || {}).to_h
  end

  def schemas
    @schemas ||= ByTypeExtractor.new(parsed_json).schemas
  end

  def parsed_json
    return {} if raw_json.blank?

    @parsed_json ||= JSON.parse(raw_json).tap do
      write_to_tmp_file(JSON.pretty_unparse(it), :json) if debug?
    end
  end

  def ld_json_chunks
    doc.css("script[type*='application/ld+json'], script[type*='LD+JSON']").map(&:text)
  end

  def fetch_source
    # Gracefully handle invalid or unreachable URLs so that recipe creation
    # does not raise uncaught exceptions.  `open_uri` returns an IO-like
    # object or `nil` when it cannot be opened (for example when
    # `URI::InvalidURIError` was rescued).  Convert `nil` to an empty string
    # which downstream Nokogiri can safely parse.

    io = open_uri
    source = io&.read.to_s

    write_to_tmp_file(source, :html) if debug? && source.present?

    source
  end

  def write_to_tmp_file(contents, extension)
    filename = "#{self.class.name.underscore}-#{Time.now.to_i}.#{extension}"
    path = Rails.root.join("tmp", filename)

    File.write(path, contents)
  end

  def debug?
    Rails.env.development?
  end

  def open_uri
    URI.open(@url, "User-Agent" => USER_AGENT)
  rescue URI::InvalidURIError => e
    # Record the sanitized URL to facilitate debugging while preventing the
    # exception from bubbling up and interrupting the request lifecycle.
    Rails.logger.error("[RecipeExtractor] Invalid URL – #{e.message}: #{@url.inspect}")

    nil
  end

  class ByTypeExtractor
    def initialize(json_input)
      @parsed_json = json_input
    end

    def schemas
      find_schemas(@parsed_json)
    end

    private

    def find_schemas(parsed_json)
      schemas = {}
      deep_find_type(parsed_json) do |schema|
        types = Array.wrap(schema["@type"])
        types.each do |type|
          key = type.downcase.to_sym
          schemas[key] = schema
        end
      end
      schemas
    end

    def deep_find_type(obj, &block)
      case obj
      when Array
        obj.each { |el| deep_find_type(el, &block) }
      when Hash
        yield obj if obj.key?("@type")
        obj.values.each { |value| deep_find_type(value, &block) unless value.is_a?(String) }
      end
    end
  end
end
