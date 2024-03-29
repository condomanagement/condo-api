# frozen_string_literal: true

require "application_system_test_case"

class ReservationsTest < ApplicationSystemTestCase
  setup do
    @reservation = reservations(:one)
  end

  test "visiting the index" do
    visit reservations_url
    assert_selector "h1", text: "Reservations"
  end

  test "creating a Reservation" do
    visit reservations_url
    click_button "New Reservation"

    fill_in "Resource", with: @reservation.resource_id
    fill_in "User", with: @reservation.user_id
    click_button "Create Reservation"

    assert_text "Reservation was successfully created"
    click_button "Back"
  end

  test "updating a Reservation" do
    visit reservations_url
    click_button "Edit", match: :first

    fill_in "Resource", with: @reservation.resource_id
    fill_in "User", with: @reservation.user_id
    click_button "Update Reservation"

    assert_text "Reservation was successfully updated"
    click_button "Back"
  end

  test "destroying a Reservation" do
    visit reservations_url
    page.accept_confirm do
      click_button "Destroy", match: :first
    end

    assert_text "Reservation was successfully destroyed"
  end
end
