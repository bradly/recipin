class UsersController < ResourceController
  def permitted_params
    [:email, :password]
  end
end
