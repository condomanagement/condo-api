# frozen_string_literal: true

# rubocop:disable Rails/ThreeStateBooleanColumn

class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.boolean :required_answer

      t.timestamps
    end
  end
end

# rubocop:enable Rails/ThreeStateBooleanColumn
