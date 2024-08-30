module ResourceControllerTestHelper
  extend ActiveSupport::Concern

  def test_index_action
    get url_for(action: :index)
    assert_response :success
    assert_not_nil assigns(resource_collection_name)
  end

  def test_new_action
    get url_for(action: :new)
    assert_response :success
    assert_not_nil assigns(resource_model_name)
  end

  def test_create_action_with_valid_params
    assert_difference("#{resource_model_class}.count") do
      post url_for(action: :create), params: { resource_model_name => valid_resource_attributes }
    end
    assert_redirected_to url_for(action: :show, id: resource_model_class.last)
    assert_equal "#{resource_model_name} saved", flash[:notice]
  end

  def test_create_action_with_invalid_params
    assert_no_difference("#{resource_model_class}.count") do
      post url_for(action: :create), params: { resource_model_name => invalid_resource_attributes }
    end
    assert_response :unprocessable_entity
    assert_equal "There was a problem saving this #{resource_model_name}", flash[:alert]
  end

  def test_show_action
    resource = resource_model_class.create!(valid_resource_attributes)
    get url_for(action: :show, id: resource)
    assert_response :success
    assert_not_nil assigns(resource_model_name)
  end

  def test_edit_action
    resource = resource_model_class.create!(valid_resource_attributes)
    get url_for(action: :edit, id: resource)
    assert_response :success
    assert_not_nil assigns(resource_model_name)
  end

  def test_update_action_with_valid_params
    resource = resource_model_class.create!(valid_resource_attributes)
    patch url_for(action: :update, id: resource), params: { resource_model_name => update_resource_attributes }
    assert_redirected_to url_for(action: :show, id: resource)
    assert_equal "#{resource_model_name} saved", flash[:notice]
    resource.reload
    assert_attributes_updated(resource)
  end

  def test_update_action_with_invalid_params
    resource = resource_model_class.create!(valid_resource_attributes)
    patch url_for(action: :update, id: resource), params: { resource_model_name => invalid_resource_attributes }
    assert_response :unprocessable_entity
    assert_equal "There was a problem saving this #{resource_model_name}", flash[:alert]
  end

  def test_destroy_action
    resource = resource_model_class.create!(valid_resource_attributes)
    assert_difference("#{resource_model_class}.count", -1) do
      delete url_for(action: :destroy, id: resource)
    end
    assert_redirected_to url_for(action: :index)
    assert_equal "#{resource_model_name.titleize} was successfully deleted.", flash[:notice]
  end

  private

  def resource_model_class
    controller.resource_scope
  end

  def resource_model_name
    controller.resource_name
  end

  def resource_collection_name
    controller.collection_name
  end

  def valid_resource_attributes
    raise NotImplementedError, "Implement valid_resource_attributes in your test class"
  end

  def invalid_resource_attributes
    raise NotImplementedError, "Implement invalid_resource_attributes in your test class"
  end

  def update_resource_attributes
    raise NotImplementedError, "Implement update_resource_attributes in your test class"
  end

  def assert_resource_attributes_updated(resource)
    raise NotImplementedError, "Implement assert_resource_attributes_updated in your test class"
  end
end