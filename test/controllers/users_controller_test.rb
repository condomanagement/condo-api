# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
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
end
