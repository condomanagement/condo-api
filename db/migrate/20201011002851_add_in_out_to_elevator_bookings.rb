# frozen_string_literal: true

class AddInOutToElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :elevator_bookings, :in, :boolean
    add_column :elevator_bookings, :out, :boolean
  end
end
