class PlansController < ResourceController
  feed_enabled
  login_required

  def permitted_params
    [:name]
  end

  def create_redirect_path
    plans_path
  end
end
