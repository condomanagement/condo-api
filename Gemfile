# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.7"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 8.0"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"
# Use Puma as the app server
gem "puma", "~> 6.5"
# Use SCSS for stylesheets
gem "sass-rails", "~> 6.0"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.13"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem "csv", "~> 3.3"
gem "dotenv-rails"
gem "email_validator"
gem "pagy", "~> 9.2"
gem "webauthn", "~> 3.1"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

gem "rails-healthcheck"

# Sorbet static type checker
gem "sorbet-runtime"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rubocop", "~> 1.81"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "letter_opener"
  gem "sorbet"
  gem "tapioca", "~> 0.17", require: false
  gem "web-console", "~> 4.2"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 3.40"
  gem "selenium-webdriver", "~> 4.27"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "simplecov", "~> 0.22"
  gem "simplecov-console", "~> 0.9"
  gem "timecop", "~> 0.9"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "rubocop-rails", "~> 2.34"

gem "rubocop-capybara", "~> 2.22"
