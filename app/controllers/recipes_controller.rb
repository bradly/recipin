class RecipesController < ResourceController
  feed_enabled
  login_required

  def permitted_params
    [:name, :url, :description]
  end
end
