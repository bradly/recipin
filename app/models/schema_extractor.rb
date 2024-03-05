require 'open-uri'
require 'nokogiri'
require 'iso8601'
require 'json'
require 'action_view'

class SchemaExtractor
  include ActionView::Helpers::DateHelper

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  def initialize(url)
    @url = url
    @doc = Nokogiri::HTML(open_url)
  end

  def name
    schema.dig('headline').presence ||
      schema.dig('name').presence
  end

  def description
    schema.dig('description').presence
  end

  def image_url
    image = schema['image']
    return schema['thumbnailUrl'] if schema['thumbnailUrl']
    return image if image.is_a?(String)
    return image.first if image.is_a?(Array)
    return image['url'] if image.is_a?(Hash)
  end

  def prep_time
    duration_in_words schema.dig('prepTime').presence
  end

  def cook_time
    duration_in_words schema.dig('cookTime').presence
  end

  def total_time
    duration_in_words schema.dig('totalTime').presence
  end

  def ingredients
    schema.dig('recipeIngredient').presence
  end

  def instructions
    Array.wrap(schema.dig('recipeInstructions').presence).collect { _1['text'] }
  end

  def servings
    Array.wrap(schema.dig('recipeYield').presence).first
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

  def raw_json
    @raw_json ||= @doc.css("script[type='application/ld+json']").map(&:text).find { _1.include?('"Recipe"') }
  end

  def open_url
    @open_url ||= URI.open(@url, "User-Agent" => USER_AGENT).read
  end

  def duration_in_words(duration_string)
    return '' unless duration_string
    duration = ISO8601::Duration.new(duration_string)
    distance_of_time_in_words(Time.now, Time.now + duration.to_seconds)
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
        types = Array.wrap(schema['@type']) # Ensure it's an array
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
        yield obj if obj.key?('@type')
        obj.values.each { |value| deep_find_type(value, &block) unless value.is_a?(String) }
      end
    end
  end
end
