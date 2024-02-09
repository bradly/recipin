class RecipesController < ApplicationController
  permitted_params :name, :url, :description
end
