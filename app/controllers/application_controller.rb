class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern
  class_attribute :exposed_actions

  def self.exposes(...)
    public_send(:"exposed_actions=", ...)
  end
end
