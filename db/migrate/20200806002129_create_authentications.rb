# frozen_string_literal: true

class CreateAuthentications < ActiveRecord::Migration[6.0]
  def change
    create_table :authentications do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :emailtoken, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end
