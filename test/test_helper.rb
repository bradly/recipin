ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'minitest/autorun'
require 'mocha/minitest'
require 'vcr'

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
  end
end

def _test(...); end

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("test", "vcr")
  config.hook_into :webmock
end
