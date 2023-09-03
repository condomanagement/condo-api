# frozen_string_literal: true

require "test_helper"

class AuthenticationMailerTest < ActionMailer::TestCase
  test "authentication" do
    @user = User.new(
      name: "Test",
      email: "test@example.com",
      unit: 0
    )
    @user.save!

    my_authentication = Authentication.new(
      emailtoken: "db4e67c3-fa2e-40e2-adb0-22ad1284db79",
      token: SecureRandom.uuid,
      user: @user
    )
    email = AuthenticationMailer.registration(my_authentication)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal I18n.t("email.authentication.subject"), email.subject
    assert_equal read_fixture("confirmation").join.strip, email.text_part.body.to_s.strip.gsub("\r", "")
    assert_equal read_fixture("confirmation_html").join.strip, email.html_part.body.to_s.strip.gsub("\r", "")
  end
end
