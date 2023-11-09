# frozen_string_literal: true

require "application_system_test_case"

class ResourcesTest < ApplicationSystemTestCase
  setup do
    @resource = resources(:one)
  end

  test "visiting the index" do
    visit resources_url
    assert_selector "h1", text: "Resources"
  end

  test "creating a Resource" do
    visit resources_url
    click_button "New Resource"

    fill_in "Name", with: @resource.name
    click_button "Create Resource"

    assert_text "Resource was successfully created"
    click_button "Back"
  end

  test "updating a Resource" do
    visit resources_url
    click_button "Edit", match: :first

    fill_in "Name", with: @resource.name
    click_button "Update Resource"

    assert_text "Resource was successfully updated"
    click_button "Back"
  end

  test "destroying a Resource" do
    visit resources_url
    page.accept_confirm do
      click_button "Destroy", match: :first
    end

    assert_text "Resource was successfully destroyed"
  end
end
