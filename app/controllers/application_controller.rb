class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  class_attribute :exposed_actions

  def self.exposes(*action_names)
    public_send(:"exposed_actions=", action_names)
  end
end
