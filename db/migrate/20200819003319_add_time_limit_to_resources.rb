# frozen_string_literal: true

class AddTimeLimitToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :time_limit, :integer, default: 60
  end
end
