class RecipesController < ResourceController
  feed_enabled
  login_required
  permitted_params = [:name, :url, :description]
end
