class RecipesController < ResourceController
  feed_enabled
  login_required

  allowed_parameters :name, :url, :description
end
