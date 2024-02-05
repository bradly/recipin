class RecipesController < ApplicationController
  private

  def permitted_params
    %i(name url description)
  end
end
