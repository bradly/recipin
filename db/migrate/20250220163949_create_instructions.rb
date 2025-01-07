class CreateInstructions < ActiveRecord::Migration[8.0]
  def change
    create_table :instruction_sections do |t|
      t.string :name, null: false
      t.integer :position, default: 0, null: false
      t.references :recipe, null: false
      t.timestamps
    end

    create_table :instructions do |t|
      t.string :text, null: false
      t.string :name
      t.references :instruction_section, null: false
      t.timestamps
    end
  end
end
