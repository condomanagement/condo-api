# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class AddVaccinatedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :vaccinated, :boolean, default: false
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
