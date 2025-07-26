class CreateFailedImports < ActiveRecord::Migration[8.0]
  def change
    create_table :failed_imports do |t|
      t.string  :source_url, null: false
      t.text    :error_message, null: false
      t.json    :context
      t.timestamps
    end
  end
end
