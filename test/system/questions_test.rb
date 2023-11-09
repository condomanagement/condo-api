# frozen_string_literal: true

require "application_system_test_case"

class QuestionsTest < ApplicationSystemTestCase
  setup do
    @question = questions(:one)
  end

  test "visiting the index" do
    visit questions_url
    assert_selector "h1", text: "Questions"
  end

  test "creating a Question" do
    visit questions_url
    click_button "New Question"

    fill_in "Question", with: @question.question
    check "Required answer" if @question.required_answer
    click_button "Create Question"

    assert_text "Question was successfully created"
    click_button "Back"
  end

  test "updating a Question" do
    visit questions_url
    click_button "Edit", match: :first

    fill_in "Question", with: @question.question
    check "Required answer" if @question.required_answer
    click_button "Update Question"

    assert_text "Question was successfully updated"
    click_button "Back"
  end

  test "destroying a Question" do
    visit questions_url
    page.accept_confirm do
      click_button "Destroy", match: :first
    end

    assert_text "Question was successfully destroyed"
  end
end
