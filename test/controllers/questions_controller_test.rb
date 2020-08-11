# frozen_string_literal: true

require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
    @authentication = authentications(:two)
    @token = @authentication.token
  end

  test "should not create question if not authorized" do
    post questions_url, params: {
      question: {
        question: @question.question,
        required_answer: @question.required_answer
      }
    }
    assert_response :unauthorized
  end

  test "should create question" do
    assert_difference("Question.count") do
      post questions_url, params: {
        question: {
          question: @question.question,
          required_answer: @question.required_answer
        }
      }, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end

    assert_response :created
  end

  test "should not update question if not authorized" do
    patch question_url(@question), params: {
      question: {
        question: @question.question,
        required_answer: @question.required_answer
      }
    }
    assert_response :unauthorized
  end

  test "should update question" do
    patch question_url(@question), params: {
      question: {
        question: @question.question,
        required_answer: @question.required_answer
      }
    }, headers: {
      "HTTP_COOKIE" => "token=" + @token + ";"
    }
    assert_response :ok
  end

  test "should not destroy question if not authorized" do
    assert_difference("Question.count", 0) do
      delete question_url(@question)
    end

    assert_response :unauthorized
  end

  test "should destroy question" do
    assert_difference("Question.count", -1) do
      delete question_url(@question), params: {}, headers: {
        "HTTP_COOKIE" => "token=" + @token + ";"
      }
    end

    assert_response :no_content
  end
end
