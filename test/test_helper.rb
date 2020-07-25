# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start "rails" do
  add_filter "app/channels/application_cable/connection.rb"
  add_filter "app/channels/application_cable/channel.rb"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/helpers/application_helper.rb"
end

if ENV["CI"] == "true"
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

# require_relative "../config/environment"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "support/action_mailer_helpers"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ActionMailerHelpers
end
