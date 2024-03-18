class AddUserToRecipes < ActiveRecord::Migration[7.1]
  def up
    default =  User.limit(1).pluck(:id).first || 0
    add_reference :recipes, :user, null: false, foreign_key: true, default: default
    change_column_default :recipes, :user_id, nil
  end

  def down
    remove_reference :recipes, :user
  end
end
