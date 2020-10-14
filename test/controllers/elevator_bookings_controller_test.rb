# frozen_string_literal: true

require "test_helper"

class ElevatorBookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @elevator_booking = elevator_bookings(:one)
    @authentication = authentications(:two)
    @token = @authentication.token
    @user_one_auth = authentications(:one)
    @user_token = @user_one_auth.token
  end

  test "shoould not get index if not admin" do
    get elevator_bookings_url
    assert_response :unauthorized
  end

  test "should get index if authorized" do
    get elevator_bookings_url, headers: { "HTTP_COOKIE" => "token=" + @token + ";" }
    assert_response :ok
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
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          unit: @elevator_booking.unit,
          user_id: @elevator_booking.user_id,
          in: @elevator_booking.in
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end
    assert_response :created
  end

  test "should not create elevator_booking if invalid token" do
    assert_difference("ElevatorBooking.count", 0) do
      post elevator_bookings_url, params: {
        elevator_booking: {
          deposit: @elevator_booking.deposit,
          end: @elevator_booking.end,
          moveType: @elevator_booking.moveType,
          name1: @elevator_booking.name1,
          name2: @elevator_booking.name2,
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          unit: @elevator_booking.unit,
          user_id: @elevator_booking.user_id
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + "aaaa;"
      }
    end

    assert_response :unauthorized
  end

  test "should not create elevator_booking without unit number" do
    assert_difference("ElevatorBooking.count", 0) do
      post elevator_bookings_url, params: {
        elevator_booking: {
          deposit: @elevator_booking.deposit,
          end: @elevator_booking.end,
          moveType: @elevator_booking.moveType,
          name1: @elevator_booking.name1,
          name2: @elevator_booking.name2,
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          user_id: @elevator_booking.user_id,
          in: @elevator_booking.in
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end
    failure = { error: "Unit number is required" }
    assert_equal failure.to_json, @response.body
    assert_response :unauthorized
  end

  test "should not create elevator_booking without name" do
    assert_difference("ElevatorBooking.count", 0) do
      post elevator_bookings_url, params: {
        elevator_booking: {
          deposit: @elevator_booking.deposit,
          end: @elevator_booking.end,
          moveType: @elevator_booking.moveType,
          name2: @elevator_booking.name2,
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          unit: @elevator_booking.unit,
          user_id: @elevator_booking.user_id,
          in: @elevator_booking.in
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end
    failure = { error: "Name is required" }
    assert_equal failure.to_json, @response.body
    assert_response :unauthorized
  end

  test "should not create elevator_booking without checking in/out" do
    assert_difference("ElevatorBooking.count", 0) do
      post elevator_bookings_url, params: {
        elevator_booking: {
          deposit: @elevator_booking.deposit,
          end: @elevator_booking.end,
          moveType: @elevator_booking.moveType,
          name1: @elevator_booking.name1,
          name2: @elevator_booking.name2,
          phone_day: @elevator_booking.phone_day,
          phone_night: @elevator_booking.phone_night,
          start: @elevator_booking.start,
          unit: @elevator_booking.unit,
          user_id: @elevator_booking.user_id,
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end
    failure = { error: "Please check at least one in/out option" }
    assert_equal failure.to_json, @response.body
    assert_response :unauthorized
  end

  test "should destroy elevator_booking" do
    assert_difference("ElevatorBooking.count", -1) do
      delete elevator_booking_url(@elevator_booking), params: {}, headers: {
        "HTTP_COOKIE" => "token=" + @user_token + ";"
      }
    end

    assert_response :no_content
  end

  test "should not destroy elevator_booking if unauthorized" do
    assert_difference("ElevatorBooking.count", 0) do
      delete elevator_booking_url(@elevator_booking), params: {}, headers: {
        "HTTP_COOKIE" => "token=" + @user_token + "aaaaa;"
      }
    end

    assert_response :no_content
  end

  test "should not destroy elevator_booking if wrong user" do
    assert_difference("ElevatorBooking.count", 0) do
      delete elevator_booking_url(@elevator_booking), params: {}, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end

    assert_response :no_content
  end

  test "should not approve booking if not admin" do
    patch elevator_booking_approve_url(@elevator_booking), params: {
      elevator_booking: {
        approved: true
      }
    }, headers: {
      "HTTP_COOKIE" => "token=" + @user_token + ";"
    }
    assert_response :unauthorized
  end

  test "should approve booking if admin" do
    patch elevator_booking_approve_url(@elevator_booking), params: {
      elevator_booking: {
        approved: true
      }
    }, headers: {
      "HTTP_COOKIE" => "token=" + @token + ";"
    }
    assert_response :ok
  end
end
