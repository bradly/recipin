require "open-uri"
require "nokogiri"
require "json"

class RecipeExtractor
  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  def initialize(url)
    @url = url
  end

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
      instruction_setions:,
    }
  end

  private

  def string(*keys)
    SchemaExtractor::String.extract(*keys)
  end

  def image(*keys)
    SchemaExtractor::Image.extract(*keys)
  end

  def duration(*keys)
    SchemaExtractor::Duration.extract(*keys)
  end

  def ingredients
    SchemaExtractor::Ingredients.extract(:recipeIngredient)
  end

  def instruction_sections
    SchemaExtractor::InstructionSections.extract(:recipeInstructions)
  end
 
  def doc
    @doc ||= Nokogiri::HTML(fetch_source)
  end

  def raw_json
    @raw_json ||= ld_json_chunks.find { it.include?("Recipe") }
  end

  def schema
    @schemas ||= (schemas[:recipe] || schemas[:article]).to_h
  end

  def schemas
    @schemas ||= SchemaExtractor::ByTypeExtractor.new(parsed_json).schemas
  end

  def parsed_json
    @parsed_json ||= JSON.parse(raw_json).tap do
      write_to_tmp_file(JSON.pretty_unparse(it), :json) if debug?
    end
  end

  def ld_json_chunks
    doc.css("script[type*='application/ld+json'], script[type*='LD+JSON']").map(&:text)
  end

  def fetch_source
    open_uri.read.tap do
      write_to_tmp_file(it, :html) if debug?
    end
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
