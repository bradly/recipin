class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.timestamps

      t.string "name"
      t.string "url"
      t.string "image_url"
      t.text "description"
      t.text "schema"
      t.text "data"
      t.string "prep_time"
      t.string "cook_time"
      t.string "total_time"
      t.text "instructions"
      t.text "ingredients"
      t.string "servings"
    end
  end
end
