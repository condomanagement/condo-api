# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :unit
      t.string :email
      t.string :phone
      t.boolean :active
      t.boolean :admin

      t.timestamps
    end
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
