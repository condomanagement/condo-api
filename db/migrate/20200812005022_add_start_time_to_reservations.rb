# frozen_string_literal: true

class AddStartTimeToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :start_time, :datetime
  end
end
