# frozen_string_literal: true

class RemoveOwnerTypeFromElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    remove_column :elevator_bookings, :ownerType
  end
end
