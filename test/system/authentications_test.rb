# frozen_string_literal: true

require "application_system_test_case"

class AuthenticationsTest < ApplicationSystemTestCase
  setup do
    @authentication = authentications(:one)
  end

  test "visiting the index" do
    visit authentications_url
    assert_selector "h1", text: "Authentications"
  end

  test "creating a Authentication" do
    visit authentications_url
    click_button "New Authentication"

    fill_in "Emailtoken", with: @authentication.emailtoken
    fill_in "Token", with: @authentication.token
    fill_in "User", with: @authentication.user_id
    click_button "Create Authentication"

    assert_text "Authentication was successfully created"
    click_button "Back"
  end

  test "updating a Authentication" do
    visit authentications_url
    click_button "Edit", match: :first

    fill_in "Emailtoken", with: @authentication.emailtoken
    fill_in "Token", with: @authentication.token
    fill_in "User", with: @authentication.user_id
    click_button "Update Authentication"

    assert_text "Authentication was successfully updated"
    click_button "Back"
  end

  test "destroying a Authentication" do
    visit authentications_url
    page.accept_confirm do
      click_button "Destroy", match: :first
    end

    assert_text "Authentication was successfully destroyed"
  end
end
