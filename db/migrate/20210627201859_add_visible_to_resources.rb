# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class AddVisibleToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :visible, :boolean, default: true
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
