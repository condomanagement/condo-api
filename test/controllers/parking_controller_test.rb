# frozen_string_literal: true

require "test_helper"

class ParkingControllerTest < ActionDispatch::IntegrationTest
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
    [:unit, :make, :color, :license, :start_date, :end_date, :contact].each do |param|
      local_params = params[:parking].except(param)
      assert_no_enqueued_emails
      post parking_index_url, params: { parking: local_params }
      failure = { success: false }
      assert_response :success
      assert_equal failure.to_json, @response.body
      assert_no_enqueued_emails
    end
  end

  test "time too long same month" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 2)
    local_params[:end_date] = Time.local(2020, 1, 12)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { success: false }
    assert_response :success
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long multiple months first month" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 20)
    local_params[:end_date] = Time.local(2020, 2, 2)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { success: false }
    assert_response :success
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long multiple months second month" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 30)
    local_params[:end_date] = Time.local(2020, 2, 9)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { success: false }
    assert_response :success
    assert_equal failure.to_json, @response.body
    assert_no_enqueued_emails
  end

  test "time too long spans months" do
    local_params = params[:parking]
    local_params[:start_date] = Time.local(2020, 1, 20)
    local_params[:end_date] = Time.local(2020, 3, 2)
    assert_no_enqueued_emails
    post parking_index_url, params: { parking: local_params }
    failure = { success: false }
    assert_response :success
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
end
