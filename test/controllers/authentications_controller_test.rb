# frozen_string_literal: true

require "test_helper"

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @authentication = authentications(:one)
    @user = users(:one)
    @user2 = users(:two)
    @authentication = authentications(:two)
    @token = @authentication.token
    @auth_user = authentications(:one)
    @user_token = @auth_user.token
    @parking_authentication = authentications(:three)
    @parking_token = @parking_authentication.token
  end

  test "valid" do
    post valid_url, params: { token: @token }, headers: { "HTTP_COOKIE" => "token=" + @token + ";" }
    assert_response :success
  end

  test "valid user token" do
    post valid_url, params: {}, headers: { "HTTP_COOKIE" => "token=" + @user_token + ";" }
    assert_response :success
  end

  test "valid parking admin token" do
    post valid_url, params: {}, headers: { "HTTP_COOKIE" => "token=" + @parking_token + ";" }
    assert_response :success
  end

  test "login" do
    post login_url, params: { "email": @user.email }
    assert_response :ok
  end

  test "login with invalid email" do
    post login_url, params: { "email": @user.email + "oaisrent" }
    assert_response :ok
  end

  test "process login" do
    post process_login_url, params: { "emailKey": @authentication.emailtoken }
    assert_response :ok
  end

  test "process login with invalid email key" do
    post process_login_url, params: { "emailKey": @authentication.emailtoken + "ioarenstaoirsent" }
    assert_response :ok
  end

  test "logout" do
    post logout_url, params: { "token": @authentication.token }
    assert_response :ok
  end

  test "logout with invalid token" do
    post logout_url, params: { "token": @authentication.token + "oairsentoaisrten" }
    assert_response :ok
  end
end
