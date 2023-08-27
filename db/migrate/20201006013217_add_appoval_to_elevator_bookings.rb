# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class AddAppovalToElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :elevator_bookings, :approved, :boolean
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
