# Adds an `admin` flag to users for namespaced admin access.
#
# Note: All existing users will automatically receive the default value (`false`).
# If you need to promote a user to admin run, e.g.:
#
#   rails console
#   User.find_by!(email_address: "me@example.com").update!(admin: true)
#
# There is intentionally **no UI** for changing the admin flag.
class AddAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false

    # Explicitly back-fill existing rows to prevent historical NULLs in older
    # SQLite versions that may not respect the NOT NULL + DEFAULT combination
    # during column addition.
    User.update_all(admin: false)
  end
end
