class RecipesController < ResourceController
  requires_login
  permitted_params = [:name, :url, :description]
end
