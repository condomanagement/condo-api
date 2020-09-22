# frozen_string_literal: true

require "test_helper"

class ElevatorBookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @elevator_booking = elevator_bookings(:one)
  end

  test "index" do
    get elevator_bookings_url
    assert_response :success
  end

  test "should create elevator_booking" do
    assert_difference("ElevatorBooking.count") do
      post elevator_bookings_url, params: {
        elevator_booking: {
          deposit: @elevator_booking.deposit,
          end: @elevator_booking.end,
          moveType: @elevator_booking.moveType,
          name1: @elevator_booking.name1,
          name2: @elevator_booking.name2,
          ownerType: @elevator_booking.ownerType,
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          unit: @elevator_booking.unit,
          user_id: @elevator_booking.user_id
        }
      }
    end

    assert_response :created
  end

  test "should not create elevator_booking with incomplete data" do
    assert_difference("ElevatorBooking.count", 0) do
      post elevator_bookings_url, params: {
        elevator_booking: {
          deposit: @elevator_booking.deposit,
          end: @elevator_booking.end,
          moveType: @elevator_booking.moveType,
          name1: @elevator_booking.name1,
          name2: @elevator_booking.name2,
          ownerType: @elevator_booking.ownerType,
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          user_id: @elevator_booking.user_id
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should destroy elevator_booking" do
    assert_difference("ElevatorBooking.count", -1) do
      delete elevator_booking_url(@elevator_booking)
    end

    assert_response :no_content
  end
end
