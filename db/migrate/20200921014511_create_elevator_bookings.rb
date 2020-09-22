# frozen_string_literal: true

class CreateElevatorBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :elevator_bookings do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :start
      t.datetime :end
      t.integer :unit
      t.integer :ownerType
      t.string :name1
      t.string :name2
      t.string :phone_day
      t.string :phone_night
      t.integer :deposit
      t.integer :moveType

      t.timestamps
    end
  end
end
