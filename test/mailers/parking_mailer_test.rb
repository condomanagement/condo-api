# frozen_string_literal: true

require "test_helper"

class ParkingMailerTest < ActionMailer::TestCase
  parking = Parking.new(
    code: "ABC",
    unit: 1,
    make: "FAST",
    color: "Green",
    license: "banana",
    start_date: "2017-05-01",
    end_date: "2017-05-02",
    contact: "test@example.com"
  )

  test "registration" do
    email = ParkingMailer.registration(parking)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal I18n.t("email.subject"), email.subject
    assert_equal read_fixture("registration").join.strip, email.text_part.body.to_s.strip.gsub("\r", "")
    assert_equal read_fixture("registration_html").join.strip, email.html_part.body.to_s.strip.gsub("\r", "")
  end

  test "should send the correct confirmation email" do
    email = ParkingMailer.confirmation(parking)

    assert_emails 1 do
      email.deliver_now
    end
    assert_equal I18n.t("email.confirmation.subject"), email.subject
    assert_equal [parking[:contact]], email.to
    assert_equal read_fixture("confirmation").join.strip, email.text_part.body.to_s.strip.gsub("\r", "")
    assert_equal read_fixture("confirmation_html").join.strip, email.html_part.body.to_s.strip.gsub("\r", "")
  end
end
