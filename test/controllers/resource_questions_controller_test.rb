# frozen_string_literal: true

require "test_helper"

class ResourceQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resource_question = resource_questions(:one)
    @authentication = authentications(:two)
    @token = @authentication.token
  end

  test "should not create resource_question if unauthorized" do
    assert_difference("ResourceQuestion.count", 0) do
      post resource_questions_url, params: {
        resource_question: {
          question_id: @resource_question.question_id,
          resource_id: @resource_question.resource_id
        }
      }
    end

    assert_response :unauthorized
  end

  test "should create resource_question if authorized" do
    assert_difference("ResourceQuestion.count") do
      post resource_questions_url, params: {
        resource_question: {
          question_id: @resource_question.question_id,
          resource_id: @resource_question.resource_id
        }
      }, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    end

    assert_response :created
  end

  test "should not destroy resource_question if unauthorized" do
    assert_difference("ResourceQuestion.count", 0) do
      delete resource_question_url(@resource_question)
    end

    assert_response :unauthorized
  end

  test "should destroy resource_question if authorized" do
    assert_difference("ResourceQuestion.count", -1) do
      delete resource_question_url(@resource_question), params: {}, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    end

    assert_response :no_content
  end

  test "should not remove resource_question if unauthorized" do
    assert_difference("ResourceQuestion.count", 0) do
      post remove_url(@resource_question), params: {
        resource_question: {
          question_id: @resource_question.question_id,
          resource_id: @resource_question.resource_id
        }
      }
    end

    assert_response :unauthorized
  end

  test "should remove resource_question if authorized" do
    assert_difference("ResourceQuestion.count", -1) do
      post remove_url(@resource_question), params: {
        resource_question: {
          question_id: @resource_question.question_id,
          resource_id: @resource_question.resource_id
        }
      }, headers: {
        "HTTP_COOKIE" => "token=#{@token};"
      }
    end

    assert_response :no_content
  end
end
