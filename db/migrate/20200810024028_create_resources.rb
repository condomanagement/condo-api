# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.string :name

      t.timestamps
    end
  end
end
