class AccountRequestsController < ResourceController
  allow_unauthenticated_access

  private
  def resource_redirect_path
    root_path
  end

  def require_login
    false
  end

  def allowed_parameters
    [:email_address, :note]
  end
end
