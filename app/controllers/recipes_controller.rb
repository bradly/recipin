class RecipesController < ResourceController
  def require_login
    true
  end

  def allowed_parameters
    [:name, :url, :description]
  end

  def collection_scope
    resource_scope.active
  end

  helper_method def recipe
    resource
  end
end
