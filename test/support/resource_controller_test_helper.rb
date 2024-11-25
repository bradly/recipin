module ResourceControllerTestHelper
  extend ActiveSupport::Concern

  class_methods do
    def test_resource_index_action
      test "index action" do
        get url_for(action: :index)
        assert_response :success
        assert_not_nil assigns(resource_collection_name)
      end
    end

    def test_resource_new_action
      test "new action" do
        get url_for(action: :new)
        assert_response :success
        assert_not_nil assigns(resource_model_name)
      end
    end

    def test_resource_create_action_with_valid_params
      test "create action with valid params" do
        assert_difference("#{resource_model_class}.count") do
          post url_for(action: :create), params: { resource_model_name => valid_resource_attributes }
        end
        assert_redirected_to url_for(action: :show, id: resource_model_class.last)
        assert_equal "#{resource_model_name} saved", flash[:notice]
      end
    end

    def test_resource_create_action_with_invalid_params
      test "create action with invalid params" do
        assert_no_difference("#{resource_model_class}.count") do
          post url_for(action: :create), params: { resource_model_name => invalid_resource_attributes }
        end
        assert_response :unprocessable_entity
        assert_equal "There was a problem saving this #{resource_model_name}", flash[:alert]
      end
    end

    def test_resource_show_action
      test "show action" do
        resource = resource_model_class.create!(valid_resource_attributes)
        get url_for(action: :show, id: resource)
        assert_response :success
        assert_not_nil assigns(resource_model_name)
      end
    end

    def test_resource_edit_action
      test "edit action" do
        resource = resource_model_class.create!(valid_resource_attributes)
        get url_for(action: :edit, id: resource)
        assert_response :success
        assert_not_nil assigns(resource_model_name)
      end
    end

    def test_resource_update_action_with_valid_params
      test "update action with valid params" do
        resource = resource_model_class.create!(valid_resource_attributes)
        patch url_for(action: :update, id: resource), params: { resource_model_name => update_resource_attributes }
        assert_redirected_to url_for(action: :show, id: resource)
        assert_equal "#{resource_model_name} saved", flash[:notice]
        resource.reload
        assert_attributes_updated(resource)
      end
    end

    def test_resource_update_action_with_invalid_params
      test "update action with invalid params" do
        resource = resource_model_class.create!(valid_resource_attributes)
        patch url_for(action: :update, id: resource), params: { resource_model_name => invalid_resource_attributes }
        assert_response :unprocessable_entity
        assert_equal "There was a problem saving this #{resource_model_name}", flash[:alert]
      end
    end

    def test_resource_destroy_action
    test "destroy action" do
      resource = resource_model_class.create!(valid_resource_attributes)
      assert_difference("#{resource_model_class}.count", -1) do
          delete url_for(action: :destroy, id: resource)
        end
        assert_redirected_to url_for(action: :index)
        assert_equal "#{resource_model_name.titleize} was successfully deleted.", flash[:notice]
      end
    end
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
