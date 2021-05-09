# frozen_string_literal: true

class AddRejectionToElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :elevator_bookings, :rejection, :text
  end
end
