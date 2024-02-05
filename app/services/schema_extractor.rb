class SchemaExtractor < ApplicationService
  require 'open-uri'

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  attr_reader :schema

  def initialize(url)
    @url = url
  end

  def name
    schema.dig('headline').presence || schema.dig('@graph', 0, 'headline')
  end

  def description
    schema.dig('description').presence || schema.dig('@graph', 0, 'description')
  end

  def image_url
    schema.dig('thumbnailUrl').presence || schema.dig('@graph', 0, 'thumbnailUrl')
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(URI.open(@url, "User-Agent" => USER_AGENT))
  end

  def raw_schema
    doc.search("script[type='application/ld+json']").collect(&:inner_text).sort_by(&:length).last
  end

  def schema
    @schema ||= JSON.parse(raw_schema)
  end
end
