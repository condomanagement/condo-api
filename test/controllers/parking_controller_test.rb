# frozen_string_literal: true

require "test_helper"

class ParkingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authentication = authentications(:two)
    @token = @authentication.token
    @parking_authentication = authentications(:three)
    @parking_token = @parking_authentication.token
    @regular_user = authentications(:one)
    @regular_token = @regular_user.token
  end

  params =
    {
      parking: {
        code: "ABC",
        unit: 1,
        make: "FAST",
        color: "Green",
        license: "banana",
        start_date: Date.today,
        end_date: Date.tomorrow,
        contact: "test@example.com"
      }
    }
  test "index" do
    get parking_index_url
    assert_response :success
  end

  test "create" do
    local_params = params[:parking]
    assert_no_enqueued_emails
    local_params[:start_date] = Time.local(2020, 1, 2)
    local_params[:end_date] = Time.local(2020, 1, 4)
    post parking_index_url, params: { parking: local_params }
    success = { success: true }
    assert_equal success.to_json, @response.body
    assert_response :success
    assert_enqueued_emails 2
  end

  test "test failure" do
    vals = ["Unit", "Make", "Color", "License", "Start date", "End date", "Contact"]
    [:unit, :make, :color, :license, :start_date, :end_date, :contact].each_with_index do |param, i|
      local_params = params[:parking].except(param)
      assert_no_enqueued_emails
      post parking_index_url, params: { parking: local_params }
      failure = { error: "#{vals[i]} can't be blank" }
      assert_response :unauthorized
      assert_equal failure.to_json, @response.body
      assert_no_enqueued_emails
    end
  end

  test "unit cannot be a number" do
    unit_local_params = params[:parking].clone
    unit_local_params[:unit] = "TEST"
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: unit_local_params }
    failure = { error: "Unit is not a number" }
    assert_response :unauthorized
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long same month" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 2)
    local_params[:end_date] = Time.local(2020, 1, 12)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { error: "You cannot register a vehicle for this length of time." }
    assert_response :unauthorized
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long multiple months first month" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 20)
    local_params[:end_date] = Time.local(2020, 2, 2)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { error: "You cannot register a vehicle for this length of time." }
    assert_response :unauthorized
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long multiple months second month" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 30)
    local_params[:end_date] = Time.local(2020, 2, 9)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { error: "You cannot register a vehicle for this length of time." }
    assert_response :unauthorized
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long spans months" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 20)
    local_params[:end_date] = Time.local(2020, 3, 2)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { error: "You cannot register a vehicle for this length of time." }
    assert_response :unauthorized
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time fine spanning months" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 30)
    local_params[:end_date] = Time.local(2020, 2, 2)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { success: true }
    assert_response :success
    assert_equal failure.to_json, @response.body
    assert_enqueued_emails 2
  end

  test "do not display today if invalid token" do
    get today_url
    assert_response :unauthorized
  end

  test "today" do
    get today_url, headers: { "HTTP_COOKIE" => "token=#{@token};" }
    assert_response :ok
  end

  test "today as parking admin" do
    get today_url, headers: { "HTTP_COOKIE" => "token=#{@parking_token};" }
    assert_response :ok
  end

  test "do not display future if invalid token" do
    get future_url
    assert_response :unauthorized
  end

  test "future" do
    get future_url, headers: { "HTTP_COOKIE" => "token=#{@token};" }
    assert_response :ok
  end

  test "future as parking admin" do
    get future_url, headers: { "HTTP_COOKIE" => "token=#{@parking_token};" }
    assert_response :ok
  end

  test "do not display past if invalid token" do
    get past_url
    assert_response :unauthorized
  end

  test "past" do
    get past_url, headers: { "HTTP_COOKIE" => "token=#{@token};" }
    assert_response :ok
  end

  test "past as parking admin" do
    get past_url, headers: { "HTTP_COOKIE" => "token=#{@parking_token};" }
    assert_response :ok
  end

  test "past as regular user" do
    get past_url, headers: { "HTTP_COOKIE" => "token=#{@regular_token};" }
    assert_response :unauthorized
  end
end
