class AddPrepTimeToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :prep_time, :string
    add_column :recipes, :cook_time, :string
    add_column :recipes, :total_time, :string
    add_column :recipes, :instructions, :text
    add_column :recipes, :ingredients, :text
    add_column :recipes, :servings, :string
  end
end
