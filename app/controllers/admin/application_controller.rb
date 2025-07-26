module Admin
  class ApplicationController < ::ApplicationController
    before_action :require_admin

    private

    def require_admin
      unless current_user&.admin?
        redirect_to root_path,
          status: :unauthorized,
          alert: "You are not authorized to access this page."
      end
    end
  end
end
