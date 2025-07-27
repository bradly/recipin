require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  attr_reader :url, :recipe

  setup do
    @url = "https://example.org/recipe.html"
    @recipe = Recipe.new(url: @url)
    stub_extractor(name: "Waffles")
  end

  test "sets attributes on save" do
    recipe.save!
    assert_equal "Waffles", recipe.name
  end

  test "does not override existing attributes" do
    recipe.name = "Pancakes"
    recipe.save!
    assert_equal "Pancakes", recipe.name
  end

  test "updatable_attrs returns only blank metadata attributes" do
    recipe.name = "Blueberry Muffins"
    blank_attrs = recipe.updatable_attrs
    
    assert_not_includes blank_attrs, :name
    assert_includes blank_attrs, :description
  end

  test "handles nil instruction_sections gracefully" do
    # Stub extractor to return a nil value for the collection association.
    stub_extractor(name: "Toast", instruction_sections: nil)

    assert_nothing_raised do
      recipe.save!
    end

    assert_empty recipe.instruction_sections
  end

  private

  def stub_extractor(data)
    RecipeExtractor.any_instance.stubs(:data).returns(data)
  end
end
