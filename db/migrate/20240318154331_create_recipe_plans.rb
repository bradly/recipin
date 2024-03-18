class CreateRecipePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :plan_items do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
