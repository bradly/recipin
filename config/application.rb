require_relative "boot"
require_relative "../lib/ingredient_parser"

require "rails/all"

Bundler.require(*Rails.groups)

module Recipin
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.hosts << ENV["RECIPIN_HOST"] if ENV["RECIPIN_HOST"].present?
    config.action_controller.raise_on_missing_callback_actions = false
  end
end
