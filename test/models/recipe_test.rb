require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test 'vcr' do
    response = nil
    url = 'http://www.iana.org/domains/reserved'
    VCR.use_cassette("synopsis") do
      response = URI.open(url, "User-Agent" => SchemaExtractor::USER_AGENT)
    end

    assert_match /Example domains/, response.read
  end
end
