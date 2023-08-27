# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class AddVaccineToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :vaccine, :boolean, default: false
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
