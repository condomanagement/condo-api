# frozen_string_literal: true

class AddUsedToAuthentication < ActiveRecord::Migration[6.0]
  def change
    add_column :authentications, :used, :bool, default: false
  end
end
