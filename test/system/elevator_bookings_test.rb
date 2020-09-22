# frozen_string_literal: true

require "application_system_test_case"

class ElevatorBookingsTest < ApplicationSystemTestCase
  setup do
    @elevator_booking = elevator_bookings(:one)
  end

  test "visiting the index" do
    visit elevator_bookings_url
    assert_selector "h1", text: "Elevator Bookings"
  end

  test "creating a Elevator booking" do
    visit elevator_bookings_url
    click_on "New Elevator Booking"

    fill_in "Deposit", with: @elevator_booking.deposit
    fill_in "End", with: @elevator_booking.end
    fill_in "Movetype", with: @elevator_booking.moveType
    fill_in "Name1", with: @elevator_booking.name1
    fill_in "Name2", with: @elevator_booking.name2
    fill_in "Ownertype", with: @elevator_booking.ownerType
    fill_in "Phone day", with: @elevator_booking.phone_day
    fill_in "Phone night", with: @elevator_booking.phone_night
    fill_in "Start", with: @elevator_booking.start
    fill_in "Unit", with: @elevator_booking.unit
    fill_in "User", with: @elevator_booking.user_id
    click_on "Create Elevator booking"

    assert_text "Elevator booking was successfully created"
    click_on "Back"
  end

  test "updating a Elevator booking" do
    visit elevator_bookings_url
    click_on "Edit", match: :first

    fill_in "Deposit", with: @elevator_booking.deposit
    fill_in "End", with: @elevator_booking.end
    fill_in "Movetype", with: @elevator_booking.moveType
    fill_in "Name1", with: @elevator_booking.name1
    fill_in "Name2", with: @elevator_booking.name2
    fill_in "Ownertype", with: @elevator_booking.ownerType
    fill_in "Phone day", with: @elevator_booking.phone_day
    fill_in "Phone night", with: @elevator_booking.phone_night
    fill_in "Start", with: @elevator_booking.start
    fill_in "Unit", with: @elevator_booking.unit
    fill_in "User", with: @elevator_booking.user_id
    click_on "Update Elevator booking"

    assert_text "Elevator booking was successfully updated"
    click_on "Back"
  end

  test "destroying a Elevator booking" do
    visit elevator_bookings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Elevator booking was successfully destroyed"
  end
end
