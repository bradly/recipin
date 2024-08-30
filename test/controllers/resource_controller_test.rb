require "test_helper"

class ResourceControllerTest < ActionDispatch::IntegrationTest
  class TestRecipesController < ResourceController
    permitted_params :name, :url, :description
  end

  setup do
    @controller = TestRecipesController.new
    @routes = ActionDispatch::Routing::RouteSet.new.tap do |r|
      r.draw { resources :recipes }
    end
  end

  test "index action" do
    get recipes_url
    assert_response :success
  end

  test "new action" do
    get new_recipe_url
    assert_response :success
  end

  test "create action with valid params" do
    assert_difference('Recipe.count') do
      post recipes_url, params: { recipe: { name: 'Test Recipe', url: 'http://example.com', description: 'A test recipe' } }
    end

    assert_redirected_to recipe_url(Recipe.last)
    assert_equal 'recipe saved', flash[:notice]
  end

  test "create action with invalid params" do
    assert_no_difference('Recipe.count') do
      post recipes_url, params: { recipe: { name: '' } }
    end

    assert_response :unprocessable_entity
    assert_equal 'There was a problem saving this recipe', flash[:alert]
  end

  test "show action" do
    recipe = Recipe.create!(name: 'Test Recipe')
    get recipe_url(recipe)
    assert_response :success
  end

  test "edit action" do
    recipe = Recipe.create!(name: 'Test Recipe')
    get edit_recipe_url(recipe)
    assert_response :success
  end

  test "update action with valid params" do
    recipe = Recipe.create!(name: 'Test Recipe')
    patch recipe_url(recipe), params: { recipe: { name: 'Updated Recipe' } }
    assert_redirected_to recipe_url(recipe)
    assert_equal 'recipe saved', flash[:notice]
    recipe.reload
    assert_equal 'Updated Recipe', recipe.name
  end

  test "update action with invalid params" do
    recipe = Recipe.create!(name: 'Test Recipe')
    patch recipe_url(recipe), params: { recipe: { name: '' } }
    assert_response :unprocessable_entity
    assert_equal 'There was a problem saving this recipe', flash[:alert]
  end

  test "destroy action" do
    recipe = Recipe.create!(name: 'Test Recipe')
    assert_difference('Recipe.count', -1) do
      delete recipe_url(recipe)
    end
    assert_redirected_to recipes_url
    assert_equal 'Recipe was successfully deleted.', flash[:notice]
  end
end