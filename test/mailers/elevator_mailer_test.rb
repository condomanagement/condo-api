# frozen_string_literal: true

require "test_helper"

class ElevatorMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:email)
  end
  elevator_booking = ElevatorBooking.new(
    unit: 1,
    start: "2017-05-01",
    end: "2017-05-02",
    name1: "HELLO MAGGIE",
    in: true,
    moveType: 1
  )

  test "pending" do
    elevator_booking.user = @user
    elevator_booking.moveType = 1
    email = ElevatorMailer.pending(elevator_booking)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal I18n.t("email.elevator.pending_subject"), email.subject
    assert_equal read_fixture("pending").join.strip, email.text_part.body.to_s.strip.gsub(/\r/, "")
    assert_equal read_fixture("pending_html").join.strip, email.html_part.body.to_s.strip.gsub(/\r/, "")
  end

  test "pending move" do
    elevator_booking.user = @user
    elevator_booking.moveType = 2
    elevator_booking.deposit = 800
    email = ElevatorMailer.pending(elevator_booking)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal I18n.t("email.elevator.pending_subject"), email.subject
    assert_equal read_fixture("pending_move").join.strip, email.text_part.body.to_s.strip.gsub(/\r/, "")
    assert_equal read_fixture("pending_move_html").join.strip, email.html_part.body.to_s.strip.gsub(/\r/, "")
  end

  test "notification" do
    elevator_booking.user = @user
    elevator_booking.moveType = 1
    email = ElevatorMailer.notification(elevator_booking)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal I18n.t("email.elevator.pending_notification_subject"), email.subject
    assert_equal read_fixture("pending_notification").join.strip, email.text_part.body.to_s.strip.gsub(/\r/, "")
    assert_equal read_fixture("pending_notification_html").join.strip,
                 email.html_part.body.to_s.strip.gsub(/\r/, "")
  end

  test "notification move" do
    elevator_booking.user = @user
    elevator_booking.moveType = 2
    elevator_booking.deposit = 800
    email = ElevatorMailer.notification(elevator_booking)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal I18n.t("email.elevator.pending_notification_subject"), email.subject
    assert_equal read_fixture("pending_move_notification").join.strip, email.text_part.body.to_s.strip.gsub(/\r/, "")
    assert_equal read_fixture("pending_move_notification_html").join.strip,
                 email.html_part.body.to_s.strip.gsub(/\r/, "")
  end

  test "approval" do
    elevator_booking.user = @user
    email = ElevatorMailer.approval(elevator_booking)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal I18n.t("email.elevator.approved_subject"), email.subject
    assert_equal read_fixture("approval").join.strip, email.text_part.body.to_s.strip.gsub(/\r/, "")
    assert_equal read_fixture("approval_html").join.strip, email.html_part.body.to_s.strip.gsub(/\r/, "")
  end
end
