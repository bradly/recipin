ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'minitest/autorun'
require 'mocha/minitest'
# HTTP interaction recording / replay
require 'webmock/minitest'
require 'vcr'

# Configure VCR to store cassettes under `test/fixtures/vcr_cassettes`
VCR.configure do |config|
  # Store cassettes in our dedicated fixtures directory
  config.cassette_library_dir = Rails.root.join('test', 'fixtures', 'vcr_cassettes')

  # Hook VCR into WebMock so that HTTP calls are intercepted
  config.hook_into :webmock

  # Allow localhost connections (capybara, rails server, etc.)
  config.ignore_localhost = true

  # Filter environment specific data (e.g. authorization headers)
  config.filter_sensitive_data('<AUTH_TOKEN>') { ENV['AUTH_TOKEN'] }

  # When a cassette is missing, record a new one in :new_episodes mode by default.
  config.default_cassette_options = { record: :new_episodes }

  # Enable more readable names for generated cassette files
  config.configure_rspec_metadata! if config.respond_to?(:configure_rspec_metadata!)
end

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
  end
end

def _test(...); end
