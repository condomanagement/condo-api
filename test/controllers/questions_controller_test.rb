# frozen_string_literal: true

require "test_helper"

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
  end

  test "should create question" do
    assert_difference("Question.count") do
      post questions_url, params: {
        question: {
          question: @question.question,
          required_answer: @question.required_answer
        }
      }
    end

    assert_response :created
  end

  test "should update question" do
    patch question_url(@question), params: {
      question: {
        question: @question.question,
        required_answer: @question.required_answer
      }
    }
    assert_response :ok
  end

  test "should destroy question" do
    assert_difference("Question.count", -1) do
      delete question_url(@question)
    end

    assert_response :no_content
  end
end
