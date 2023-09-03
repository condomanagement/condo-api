# frozen_string_literal: true

# rubocop:disable Rails/ReversibleMigration
# rubocop:disable Rails/BulkChangeTable

class ChangeReservationTimesWithTimezone < ActiveRecord::Migration[6.0]
  def change
    change_column :reservations, :start_time, "timestamptz using start_time::timestamptz"
    change_column :reservations, :end_time, "timestamptz using end_time::timestamptz"
  end
end

# rubocop:enable Rails/ReversibleMigration
# rubocop:enable Rails/BulkChangeTable
