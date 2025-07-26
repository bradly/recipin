class ApplicationController < ActionController::Base
  include Authentication

  # Convenience accessor that proxies through to `Current.user`. Having a
  # dedicated method keeps us compatible with libraries and patterns that
  # expect a `current_user` helper to be present.
  helper_method :current_user

  def current_user
    Current.user
  end
end
