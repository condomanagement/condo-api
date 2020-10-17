# frozen_string_literal: true

class AddIndexToAuthentications < ActiveRecord::Migration[6.0]
  def change
    add_index :authentications, :token
    add_index :authentications, :emailtoken
  end
end
