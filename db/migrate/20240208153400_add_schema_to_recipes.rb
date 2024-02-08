class AddSchemaToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :schema, :text
  end
end
