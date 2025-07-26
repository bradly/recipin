class CreateFailedImports < ActiveRecord::Migration[7.1]
  def change
    create_table :failed_imports do |t|
      t.string :url
      t.text :error_message
      t.timestamps
    end
  end
end
