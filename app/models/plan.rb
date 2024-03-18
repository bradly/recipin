class Plan < ApplicationRecord
  has_many :plan_items, dependent: :destroy
  has_many :recipes, through: :plan_items

  def available_items
    Recipe.where.not(id: recipes.pluck(:id)).map do
      PlanItem.new(recipe: _1)
    end
  end
end
