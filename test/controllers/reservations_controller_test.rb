# frozen_string_literal: true

require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:one)
    @authentication = authentications(:two)
    @token = @authentication.token
    @user_one_auth = authentications(:one)
    @user_token = @user_one_auth.token
  end

  test "should not get index if unauthorized" do
    get reservations_url
    assert_response :unauthorized
  end

  test "should get index if authorized" do
    get reservations_url, headers: { "HTTP_COOKIE" => "token=#{@token};" }
    assert_response :ok
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
          "HTTP_COOKIE" => "token=#{@token};"
        }
    end

    assert_response :created
  end

  test "should not create reservation if resource_id null" do
    assert_difference("Reservation.count", 0) do
      post reservations_url, params:
        {
          reservation: {
            resource_id: "null",
            user_id: @reservation.user_id,
            start_time: "2020-01-01 20:20:00",
            end_time: "2020-01-01 20:25:00"
          },
          answers: ["[1, 1]"]
        }, headers: {
          "HTTP_COOKIE" => "token=#{@token};"
        }
    end

    assert_response :unauthorized
  end

  test "should update reservation" do
    patch reservation_url(@reservation), params:
      {
        reservation: {
          resource_id: @reservation.resource_id,
          user_id: @reservation.user_id
        }
      }, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    assert_response :ok
  end

  test "should not update reservation if missing data" do
    patch reservation_url(@reservation), params:
      {
        reservation: {
          resource_id: "ghost",
          user_id: @reservation.user_id
        }
      }, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    assert_response :unprocessable_entity
  end

  test "should not destroy reservation if unauthorized" do
    assert_difference("Reservation.count", 0) do
      delete reservation_url(@reservation)
    end

    assert_response :no_content
  end

  test "should destroy reservation" do
    assert_difference("Reservation.count", -1) do
      delete reservation_url(@reservation), params: {}, headers: { "HTTP_COOKIE" => "token=#{@user_token};" }
    end

    assert_response :no_content
  end

  test "should find my reservations" do
    get mine_url, headers: { "HTTP_COOKIE" => "token=#{@user_token};" }
    assert_response :ok
  end

  test "should find no reservations if not user" do
    get mine_url
    assert_response :unauthorized
  end

  test "find reservations" do
    @reservation.save
    post find_reservations_url, params:
      {
        resource: @reservation.id,
        startDay: "2020-01-01T04:00:00.000Z",
        endDay: "2022-01-01T-4:30:00.000Z",
        controller: "reservations",
        action: "find_reservations",
        reservations: {}
      }, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    assert_response :ok
  end

  test "find reservations fails" do
    post find_reservations_url, params:
      {
        controller: "reservations",
        action: "find_reservations",
        reservations: {}
      }, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    assert_response :unprocessable_entity
  end
end
