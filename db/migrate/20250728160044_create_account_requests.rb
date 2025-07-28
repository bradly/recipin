class CreateAccountRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :account_requests do |t|
      t.string :email_address, null: false
      t.datetime :dismissed_at
      t.text :note

      t.timestamps
    end
  end
end
