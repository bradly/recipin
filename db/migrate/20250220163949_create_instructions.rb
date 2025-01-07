class CreateInstructions < ActiveRecord::Migration[8.0]
  def change
    create_table :instructions do |t|
      t.string :text
      t.string :name
      t.references :recipe, null: false
      t.timestamps
    end
  end
end
