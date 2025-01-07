require_relative "boot"
require_relative "../lib/ingredient_parser"

require "rails/all"

Bundler.require(*Rails.groups)

module Recipin
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
