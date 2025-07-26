# frozen_string_literal: true

Sentry.init do |config|
  config.dsn     = ENV["SENTRY_DSN"]
  config.release = ENV["KAMAL_CONTAINER_NAME"]

  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.send_modules = false
  config.auto_session_tracking = false
end if ENV['SENTRY_DSN'].present?
