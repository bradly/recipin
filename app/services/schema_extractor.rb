class SchemaExtractor
  require 'open-uri'
  require 'iso8601'
  include ActionView::Helpers::DateHelper

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  attr_reader :schemas

  def initialize(url)
    @url = url
  end

  def name
    schema.dig('headline').presence ||
      schema.dig('name').presence
  end

  def description
    schema.dig('description').presence
  end

  def image_url
    return schema.dig('thumbnailUrl') if schema.dig('thumbnailUrl').presence

    case schema.dig('image')
    when String
      schema.dig('image')
    when Array
      schema.dig('image', 0)
    when Hash
      schema.dig('image', 'url')
    end
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
    @schemas ||= Hashie::Mash.new(parsed_json).
      extend(Hashie::Extensions::DeepLocate).
      deep_locate(-> (key, _, _) { key == '@type' }).
      each_with_object({}) do |schema, hash|
        hash[schema['@type'].downcase.to_sym] = schema
      end
  end

  def parsed_json
    @parsed_json ||= Array.wrap(JSON.parse(raw_json)).first
  end

  def raw_json
    @raw_json = doc.search("script[type='application/ld+json']").collect(&:inner_text).sort_by(&:length).last
  end

  def doc
    @doc ||= Nokogiri::HTML(URI.open(@url, "User-Agent" => USER_AGENT))
  end

  def duration_in_words(duration_string)
    duration = ISO8601::Duration.new(duration_string)
    distance_of_time_in_words(Time.current, duration.to_seconds.seconds.from_now)
  end
end
