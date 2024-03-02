require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Recipin
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    config.to_prepare do
      Clearance::SessionsController.layout  'sessions'
      Clearance::UsersController.layout     'sessions'
      Clearance::PasswordsController.layout 'sessions'
    end
  end
end
