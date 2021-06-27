# frozen_string_literal: true

class AddVisibleToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :visible, :boolean, default: true
  end
end
