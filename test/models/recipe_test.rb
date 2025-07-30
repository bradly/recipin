require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  attr_reader :url, :recipe

  setup do
    @url = "https://example.org/recipe.html"
    @recipe = Recipe.new(url: @url)
  end

  test "sets attributes on save" do
    stub_extractor(name: "Waffles")
    recipe.save!
    assert_equal "Waffles", recipe.name
  end

  test "does not override existing attributes" do
    stub_extractor(name: "Waffles")
    recipe.name = "Pancakes"
    recipe.save!
    assert_equal "Pancakes", recipe.name
  end

  test "updatable_attrs returns only blank metadata attributes" do
    stub_extractor(name: "Waffles")
    recipe.name = "Blueberry Muffins"
    blank_attrs = recipe.updatable_attrs
    
    assert_not_includes blank_attrs, :name
    assert_includes blank_attrs, :description
  end

  ENV["RECIPIN_TEST_URLS"].split(/\s+/).each do |test_url|
    test "correctly handles test url #{test_url}" do
      VCR.use_cassette("recipes/#{test_url.parameterize}") do
        assert Recipe.create!(url: test_url)
      end
    end
  end if ENV["RECIPIN_TEST_URLS"].present?

  private

  def stub_extractor(data)
    RecipeExtractor.any_instance.stubs(:data).returns(data)
  end
end
