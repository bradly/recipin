module Admin
  # Base controller for everything in the /admin namespace. Access is limited
  # to users who have the `admin` flag set to true.
  class ApplicationController < ::ApplicationController
    before_action :require_admin

    private

    def require_admin
      # The `Authentication` concern already ensures the user is logged in.
      unless current_user&.admin?
        redirect_to root_path, alert: "You are not authorized to access this page."
      end
    end
  end
end
