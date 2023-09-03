# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration

class RemoveOwnerTypeFromElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    remove_column :elevator_bookings, :ownerType
  end
end

# rubocop:enable Rails/ReversibleMigration
