# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["DOMAIN"] ||= "https://localhost:3001"
ENV["NUMBER_OF_DAYS"] ||= "4"
ENV["EMAIL"] ||= "test@example.com"
ENV["ELEVATOR_EMAIL_DELIVERY"] ||= "delivery@example.com"
ENV["ELEVATOR_EMAIL_MOVE"] ||= "move@example.com"

require "simplecov"
require "simplecov-console"

SimpleCov.start "rails" do
  add_filter "app/channels/application_cable/connection.rb"
  add_filter "app/channels/application_cable/channel.rb"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/helpers/application_helper.rb"
  add_filter "app/helpers/authentications_helper.rb"
end

SimpleCov.formatter = SimpleCov::Formatter::Console

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
