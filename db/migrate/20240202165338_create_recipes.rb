class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :url
      t.string :image_url
      t.text   :description


      t.timestamps
    end
  end
end
