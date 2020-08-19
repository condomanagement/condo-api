# frozen_string_literal: true

class AddTimeLimitToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :time_limit, :integer, default: 60
  end
end
