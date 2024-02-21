class SchemaExtractor
  require 'open-uri'
  require 'iso8601'

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  attr_reader :schemas

  def initialize(url)
    @url = url
  end

  def name
    data.dig('headline').presence
  end

  def description
    data.dig('description').presence
  end

  def image_url
    data.dig('thumbnailUrl').presence ||
      (data.dig('image')&.is_a?(String) && data.dig('image')).presence ||
      data.dig('image', 'url')
  end

  def prep_time
    data.dig('prepTime').presence
  end

  def prep_time_in_words
    duration_in_words(prep_time)
  end

  def cook_time
    data.dig('cookTime').presence
  end

  def cook_time_in_words
    duration_in_words(cook_time)
  end

  def total_time
    data.dig('totalTime').presence
  end

  def total_time_in_words
    duration_in_words(total_time)
  end

  def ingredients
    data.dig('recipeIngredient').presence
  end

  def instructions
    Array.wrap(data.dig('recipeInstructions').presence).collect { _1['text'] }
  end

  def servings
    Array.wrap(data.dig('recipeYield').presence).first
  end

  def data
    schemas[:recipe] || schemas[:article]
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
    duration = ISO8601::Duration.new(duration_string).to_seconds
    future_time = duration.seconds.from_now
    ActionView::Helpers::DateHelper.distance_of_time_in_words(Time.current, future_time)
  end
end
