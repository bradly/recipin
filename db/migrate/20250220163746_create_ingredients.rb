class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.string :text, null: false

      t.string :name
      t.string :amount
      t.string :size
      t.string :preparation
      t.string :comment
      t.string :purpose
      t.string :sentence
      t.references :recipe, null: false

      t.timestamps
    end
  end
end
