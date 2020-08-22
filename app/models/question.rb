# frozen_string_literal: true

class Question < ApplicationRecord
  default_scope { order(question: :asc) }
  has_many :resource_questions, dependent: :destroy
  has_many :resources, through: :resource_questions
end
