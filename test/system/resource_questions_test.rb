# frozen_string_literal: true

require "application_system_test_case"

class ResourceQuestionsTest < ApplicationSystemTestCase
  setup do
    @resource_question = resource_questions(:one)
  end

  test "visiting the index" do
    visit resource_questions_url
    assert_selector "h1", text: "Resource Questions"
  end

  test "creating a Resource question" do
    visit resource_questions_url
    click_on "New Resource Question"

    fill_in "Question", with: @resource_question.question_id
    fill_in "Resource", with: @resource_question.resource_id
    click_on "Create Resource question"

    assert_text "Resource question was successfully created"
    click_on "Back"
  end

  test "updating a Resource question" do
    visit resource_questions_url
    click_on "Edit", match: :first

    fill_in "Question", with: @resource_question.question_id
    fill_in "Resource", with: @resource_question.resource_id
    click_on "Update Resource question"

    assert_text "Resource question was successfully updated"
    click_on "Back"
  end

  test "destroying a Resource question" do
    visit resource_questions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Resource question was successfully destroyed"
  end
end
