class SchemaExtractor
  require "open-uri"
  require "nokogiri"
  require "json"
  require "iso8601"
  require "action_view"

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  class Extractor
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

  class ImageExtractor < Extractor
    def extract
      case value = super
      when Hash
        value["url"]
      when Array
        value.first
      else
        value
      end
    end
  end

  class ArrayOfStringsExtractor < Extractor
    def extract
      super.map do
        case it
        when Hash
          it["text"]
        else
          it
        end
      end
    end
  end

  class DurationExtractor < Extractor
    include ActionView::Helpers::DateHelper

    def extract
      duration_in_words super
    end

    private

    def duration_in_words(duration_string)
      return "" unless duration_string
      duration = ISO8601::Duration.new(duration_string)
      distance_of_time_in_words(Time.now, Time.now + duration.to_seconds)
    end
  end

  module Helpers
    def extract(*keys)
      Extractor.extract(schema, *keys)
    end

    def extract_string(*keys)
      Extractor.extract(schema, *keys)
    end

    def extract_array_of_string(*keys)
      ArrayOfStringsExtractor.extract(schema, *keys)
    end

    def extract_image(*keys)
      ImageExtractor.extract(schema, *keys)
    end

    def extract_duration(*keys)
      DurationExtractor.extract(schema, *keys)
    end
  end

  def initialize(url)
    @url = url
    @doc = Nokogiri::HTML(raw_source)
  end

  def name
    extract_string("headline", "name")
  end

  def description
    extract_string("description")
  end

  def image_url
    extract_image("image", "thumbnailUrl")
  end

  def prep_time
    extract_duration("prepTime")
  end

  def cook_time
    extract_duration("cookTime")
  end

  def total_time
    extract_duration("totalTime")
  end

  class IngredientExtractor
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def call
      {
        text:,
        name: data.name,
        amount: data.amount,
        size: data.size,
        preparation: data.preparation,
        comment: data.comment,
        purpose: data.purpose,
        sentence: data.sentence,
      }
    end

    def data
      Ingredient.find_by(text:) || parser
    end

    private

    def parser
      @parser ||= IngredientParser.new(text)
    end
  end

  def ingredients
    extract_array_of_string("recipeIngredient")
      .map { IngredientExtractor.new(_1).call }
      .map { Ingredient.new(_1) }
  end

  def instructions
    base_instructions = extract("recipeInstructions")

    steps = base_instructions
      .select { _1["@type"] == "HowToStep" }

    if steps.blank?
      steps = base_instructions
        .find { _1.values_at("@type", "name") == ["HowToSection", "Recipe Instructions"] }
       &.dig("itemListElement")
       &.map { { text: _1["text"] } }
    end

    steps
      .map { it.with_indifferent_access.slice(:text, :name) }
      .map { Instruction.new(it) }
  end

  def servings
    extract_string("recipeYield")
  end

  def raw_json
    @raw_json ||= ld_json_chunks.find { it.include?("Recipe") }
  end

  def schema
    @schemas ||= (schemas[:recipe] || schemas[:article]).to_h
  end

  private
  include Helpers

  def schemas
    @schemas ||= ByTypeExtractor.new(parsed_json).schemas
  end

  def parsed_json
    @parsed_json ||= JSON.parse(raw_json).tap do
      write_to_tmp_file(JSON.pretty_unparse(it), :json) if debug?
    end
  end

  def ld_json_chunks
    @doc.css("script[type*='application/ld+json'], script[type*='LD+JSON']").map(&:text)
  end

  def raw_source
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

  def schema_dig(attr, keys = :text)
    keys = Array.wrap(keys).map(&:to_s)

    Array.wrap(schema.dig(attr.to_s).presence).collect do |value|
      case value
      when Hash
        value.slice(*keys).first
      when Array
        value.first
      else
        value
      end
    end
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
