class SchemaExtractor
  require "open-uri"
  require "nokogiri"
  require "json"
  require "iso8601"
  require "action_view"

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  class BaseExtractor
    def initialize(schema, *keys)
      @schema = schema
      @keys = keys
    end

    def self.extract(...)
      new(...).extract
    end

    def extract
      key = @keys.find { @schema[_1].presence }
      @schema[key]
    end
  end

  StringExtractor = Class.new(BaseExtractor)

  class DurationExtractor < BaseExtractor
    include ActionView::Helpers::DateHelper


    def extract
      duration_string = super
     duration_in_words(duration_string)
    end

    private

    def duration_in_words(duration_string)
      return "" unless duration_string
      duration = ISO8601::Duration.new(duration_string)
      distance_of_time_in_words(Time.now, Time.now + duration.to_seconds)
    end
  end

  class ImageExtractor < BaseExtractor
    def extract
      image = super

      case image
      when Array
        image.first
      when Hash
        image["url"]
      else
        image
      end
    end
  end

  def initialize(url)
    @url = url
    @doc = Nokogiri::HTML(open_url)
  end

  def name
    StringExtractor.extract(schema, "headline", "name")
  end

  def description
    StringExtractor.extract(schema, "description")
  end

  def image_url
    ImageExtractor.extract(schema, "image", "thumbnailUrl")
  end

  def prep_time
    DurationExtractor.extract(schema, "prepTime")
  end

  def cook_time
    DurationExtractor.extract(schema, "cookTime")
  end

  def total_time
    DurationExtractor.extract(schema, "totalTime")
  end

  def ingredients
    Array.wrap(schema.dig("recipeIngredient").presence).collect { _1["text"] }
  end

  def instructions
    Array.wrap(schema.dig("recipeInstructions").presence).collect { _1["text"] }
  end

  def servings
    Array.wrap(schema.dig("recipeYield").presence).first
  end

  def schema
    (schemas[:recipe] || schemas[:article]).to_h
  end

  def schemas
    @schemas ||= ByTypeExtractor.new(parsed_json).schemas
  end

  def parsed_json
    @parsed_json ||= JSON.parse(raw_json)
  end

  def ld_json_chunks
    @doc.css("script[type*='application/ld+json'], script[type*='LD+JSON']").map(&:text)
  end

  def raw_json
    @raw_json ||= ld_json_chunks.find { _1.include?("Recipe") }
  end

  def open_url
    @open_url ||= URI.open(@url, "User-Agent" => USER_AGENT).read
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
