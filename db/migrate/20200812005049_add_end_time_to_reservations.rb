# frozen_string_literal: true

class AddEndTimeToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :end_time, :datetime
  end
end
