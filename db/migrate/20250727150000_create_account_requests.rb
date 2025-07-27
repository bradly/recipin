# frozen_string_literal: true

class CreateAccountRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :account_requests do |t|
      t.string  :email,     null: false
      t.text    :note
      t.boolean :dismissed, null: false, default: false

      t.timestamps
    end

    add_index :account_requests, :email
  end
end
