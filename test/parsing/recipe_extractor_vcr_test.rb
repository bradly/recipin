require 'test_helper'

# Test harness that verifies RecipeExtractor can parse a real-world recipe
# page using a VCR cassette.  The cassette file itself is *not* committed
# to the repo; instead we skip the assertion unless a cassette has already
# been recorded locally.

class RecipeExtractorVCRTest < ActiveSupport::TestCase
  CASSETTE_NAME = 'example_recipe'
  TEST_URL      = 'https://www.allrecipes.com/recipe/24074/alysias-basic-meat-lasagna'

  test 'extract recipe data via recorded HTTP interaction' do
    cassette_file = Rails.root.join('test', 'fixtures', 'vcr_cassettes', "#{CASSETTE_NAME}.yml")

    # Skip in CI or first-run scenarios where the cassette does not yet exist.
    skip "VCR cassette not present (run `bin/rails parsing:record_vcr[#{TEST_URL}]` to create it)" unless File.exist?(cassette_file)

    VCR.use_cassette(CASSETTE_NAME) do
      extractor = RecipeExtractor.new(TEST_URL)
      data = extractor.data

      # Minimal smoke tests – adjust / extend as needed when new cassettes are added.
      assert data[:name].present?, 'recipe name should be present'
      assert data[:ingredients].present?, 'ingredients should be present'
      assert data[:instruction_sections].present?, 'instruction sections should be present'
    end
  end
end
