# frozen_string_literal: true

class AddParkingAdminToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :parking_admin, :boolean
  end
end
