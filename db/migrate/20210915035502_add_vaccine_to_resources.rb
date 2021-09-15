# frozen_string_literal: true

class AddVaccineToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :vaccine, :boolean, default: false
  end
end
