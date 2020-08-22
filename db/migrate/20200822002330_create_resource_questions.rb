# frozen_string_literal: true

class CreateResourceQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :resource_questions do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
