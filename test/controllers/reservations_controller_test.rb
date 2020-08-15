# frozen_string_literal: true

require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
    @authentication = authentications(:two)
    @token = @authentication.token
  end

  test "should create reservation" do
    assert_difference("Reservation.count") do
      post reservations_url, params:
        {
          reservation: {
            resource_id: @reservation.resource_id,
            user_id: @reservation.user_id,
            start_time: "2020-01-01 20:20:00",
            end_time: "2020-01-01 20:25:00"
          },
          answers: ["[1, 1]"]
        }, headers: {
          "HTTP_COOKIE" => "token=" + @token + ";"
        }
    end

    assert_response :created
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params:
      {
        reservation: {
          resource_id: @reservation.resource_id,
          user_id: @reservation.user_id
        }
      }
    assert_response :ok
  end

  # test "should destroy reservation" do
  #  assert_difference("Reservation.count", -1) do
  #    delete reservation_url(@reservation)
  #  end

  #  assert_response :no_content
  # end
end
