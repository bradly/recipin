source "https://rubygems.org"

gem "rails"
gem "bootsnap"
gem "net-smtp", "~> 0.5.1", require: false
gem "propshaft"
gem "sqlite3"
gem "haml-rails"
gem "puma"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "iso8601"

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
