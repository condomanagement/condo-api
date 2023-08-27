# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class AddParkingAdminToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :parking_admin, :boolean
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
