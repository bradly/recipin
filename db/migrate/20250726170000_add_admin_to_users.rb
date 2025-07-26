class AddAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false

    # Explicitly back-fill existing rows to prevent historical NULLs in older
    # SQLite versions that may not respect the NOT NULL + DEFAULT combination
    # during column addition.
    User.update_all(admin: false)
  end
end
