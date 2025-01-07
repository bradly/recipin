class UsersController < ResourceController
  def require_login
    true
  end

  def allowed_parameters
    [:name, :email, :password]
  end

  helper_method def user
    resource
  end
end
