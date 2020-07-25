# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user2 = users(:two)
    @user3 = users(:three)
    @users = [@user, @user2, @user3]
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params:
        {
          user: {
            active: @user.active,
            admin: @user.admin,
            email: @user.email,
            name: @user.name,
            phone: @user.phone,
            unit: @user.unit
          }
        }
    end

    assert_response :created
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params:
      {
        user: {
          active: @user.active,
          admin: @user.admin,
          email: @user.email,
          name: @user.name,
          phone: @user.phone,
          unit: @user.unit
        }
      }
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_response :success
  end

  test "should not allow invalid token to update users" do
    auth_token = ENV["ADMINISTRATIVE_TOKEN"] + "boo"
    post upload_url, params: { body: @users.to_json }, headers: { "X-Administrative-Token" => auth_token }
    assert_response :unprocessable_entity
    err = { error: "invalid_token" }
    assert_equal @response.body, err.to_json
  end

  test "valid token and data should update users" do
    auth_token = ENV["ADMINISTRATIVE_TOKEN"]
    @user.id = nil
    @user2.id = nil
    @users = [@user, @user2]
    post upload_url, params: { body: @users.to_json }, headers: { "X-Administrative-Token" => auth_token }
    assert_response :success
  end

  test "invalid data should not post" do
    auth_token = ENV["ADMINISTRATIVE_TOKEN"]
    post upload_url, params: { body: "{{not_valid: json}" }, headers: { "X-Administrative-Token" => auth_token }
    assert_response :unprocessable_entity
    err = { error: "invalid_json" }
    assert_equal @response.body, err.to_json
  end

  test "missing data should not post" do
    auth_token = ENV["ADMINISTRATIVE_TOKEN"]
    @user.id = nil
    @user2.id = nil
    @users = [@user, @user2, @user3]
    post upload_url, params: { body: @users.to_json }, headers: { "X-Administrative-Token" => auth_token }
    assert_response :unprocessable_entity
    err = { error: "missing_required_fields" }
    assert_equal @response.body, err.to_json
  end
end
