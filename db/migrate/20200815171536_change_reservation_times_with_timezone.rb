# frozen_string_literal: true

class ChangeReservationTimesWithTimezone < ActiveRecord::Migration[6.0]
  def change
    change_column :reservations, :start_time, "timestamptz using start_time::timestamptz"
    change_column :reservations, :end_time, "timestamptz using end_time::timestamptz"
  end
end
