# frozen_string_literal: true

require "test_helper"

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resource = resources(:one)
    @authentication = authentications(:two)
    @token = @authentication.token
  end

  test "should not create resource if unauthorized" do
    post resources_url, params: { resource: { name: @resource.name } }

    assert_response :unauthorized
  end

  test "should create resource" do
    assert_difference("Resource.count") do
      post resources_url, params: {
        resource: {
          name: @resource.name
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end

    assert_response :created
  end

  test "should not update resource if unauthorized" do
    patch resource_url(@resource), params: { resource: { name: @resource.name } }
    assert_response :unauthorized
  end

  test "should update resource" do
    patch resource_url(@resource),
          params: {
            resource: { name: @resource.name }
          },
          headers: {
            "HTTP_COOKIE" => "token=" + @token + ";"
          }
    assert_response :ok
  end

  test "should not destroy resource if unauthorized" do
    assert_difference("Resource.count", 0) do
      delete resource_url(@resource)
    end

    assert_response :unauthorized
  end

  test "should destroy resource" do
    assert_difference("Resource.count", -1) do
      delete resource_url(@resource), params: {}, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end

    assert_response :no_content
  end
end
