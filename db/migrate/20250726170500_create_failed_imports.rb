# Stores information about imports that could not be processed so that they
# can be inspected and (optionally) retried from the admin UI.
class CreateFailedImports < ActiveRecord::Migration[8.0]
  def change
    create_table :failed_imports do |t|
      t.string  :source_url, null: false
      t.text    :error_message, null: false
      t.json    :context
      t.timestamps
    end

    add_index :failed_imports, :created_at
  end
end
