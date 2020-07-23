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
  test "create" do
    assert_no_enqueued_emails
    post parking_index_url, params: params
    success = { success: true }
    assert_equal success.to_json, @response.body
    assert_response :success
    assert_enqueued_emails 2
  end
end
