require "test_helper"

class SchemaExtractorTest < ActiveSupport::TestCase
  test 'setting attributes' do
    attrs = [
      "name",
      "image_url",
      "description",
      "schema",
      "instructions",
      "ingredients",
    ]

    urls.each do |url|
      VCR.use_cassette(url.parameterize) do
        se = SchemaExtractor.new(url)
        attrs.each { assert se.public_send(_1).present? }
      end
    end
  end

  def urls
    File.read("test/vcr_cassettes/schema_extractor/urls.txt").split("\n")
  end

  def url_host(url)
    URI.parse(url).host.remove /\Awww\./
  end
end
