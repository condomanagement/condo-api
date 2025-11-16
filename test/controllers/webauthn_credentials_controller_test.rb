# frozen_string_literal: true

require "test_helper"

class WebauthnCredentialsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @authentication = authentications(:one)
    @token = @authentication.token
  end

  test "should get registration options when authenticated" do
    get webauthn_registration_options_url, headers: { "HTTP_COOKIE" => "token=#{@token};" }
    assert_response :success
    json = response.parsed_body
    assert json["challenge"]
    assert json["rp"]
    assert json["user"]
  end

  test "should not get registration options when not authenticated" do
    get webauthn_registration_options_url
    assert_response :unauthorized
  end

  test "should not get authentication options without email" do
    get webauthn_authentication_options_url
    assert_response :bad_request
  end

  test "should check passkey availability" do
    get webauthn_check_availability_url(email: @user.email)
    assert_response :success
    json = response.parsed_body
    assert_not_nil json["passkeys_available"]
  end
end
