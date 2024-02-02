class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :url
      t.text :summary


      t.timestamps
    end
  end
end
