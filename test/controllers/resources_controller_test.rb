# frozen_string_literal: true

require "test_helper"

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resource = resources(:one)
  end

  test "should create resource" do
    assert_difference("Resource.count") do
      post resources_url, params: { resource: { name: @resource.name } }
    end

    assert_response :created
  end

  test "should update resource" do
    patch resource_url(@resource), params: { resource: { name: @resource.name } }
    assert_response :ok
  end

  test "should destroy resource" do
    assert_difference("Resource.count", -1) do
      delete resource_url(@resource)
    end

    assert_response :no_content
  end
end
