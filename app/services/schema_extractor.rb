class SchemaExtractor
  require 'open-uri'

  USER_AGENT = "Mozilla/5.0 (Linux; Android 10; SM-G996U Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Mobile Safari/537.36"

  attr_reader :schema

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

  def data(needle = '@type')
    @data ||= begin
                Hashie::Mash.new(schema)
                  .extend(Hashie::Extensions::DeepLocate)
                  .deep_locate(-> (key, _, _) { key == needle })
                  .first
              end
  end

  def schema
    @schema ||= Array.wrap(JSON.parse(raw_schema)).first
  end

  private

  def doc
    @doc ||= Nokogiri::HTML(URI.open(@url, "User-Agent" => USER_AGENT))
  end

  def raw_schema
    doc.search("script[type='application/ld+json']").collect(&:inner_text).sort_by(&:length).last
  end
end
