# frozen_string_literal: true

class AddAppovalToElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :elevator_bookings, :approved, :boolean
  end
end
