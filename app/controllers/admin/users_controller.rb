module Admin
  class UsersController < ResourceController
    def allowed_parameters
      [:name, :email, :admin]
    end

    def resource_redirect_path
      [:admin, :users]
    end
  end
end
