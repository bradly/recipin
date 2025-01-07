class IngredientsController < ResourceController
  def require_login
    true
  end

  helper_method def ingredient
    resource
  end
end
