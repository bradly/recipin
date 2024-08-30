require "test_helper"
require "helpers/resource_controller_test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  include ResourceControllerTestHelper

  test_resource_index_action
  test_resource_new_action
  test_resource_create_action_with_valid_params
  test_resource_create_action_with_invalid_params
  test_resource_show_action
  test_resource_edit_action
  test_resource_update_action_with_valid_params
  test_resource_update_action_with_invalid_params
  test_resource_destroy_action
  
  private

  def valid_resource_attributes
    {
      name: "Test Recipe",
      url: "http://example.com/recipe",
      description: "A delicious test recipe"
    }
  end

  def invalid_resource_attributes
    {
      name: "",
      url: "invalid-url",
      description: ""
    }
  end

  def update_resource_attributes
    {
      name: "Updated Recipe",
      url: "http://example.com/updated-recipe",
      description: "An updated test recipe"
    }
  end

  def assert_resource_attributes_updated(resource)
    assert_equal "Updated Recipe", resource.name
    assert_equal "http://example.com/updated-recipe", resource.url
    assert_equal "An updated test recipe", resource.description
  end
end
