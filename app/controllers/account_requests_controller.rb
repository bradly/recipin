class AccountRequestsController < ResourceController
  private
  def create_redirect_path
    root_path
  end

  def require_login
    false
  end

  def allowed_parameters
    [:email_address, :note]
  end
end
