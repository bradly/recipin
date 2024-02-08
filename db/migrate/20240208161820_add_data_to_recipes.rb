class AddDataToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :data, :text
  end
end
