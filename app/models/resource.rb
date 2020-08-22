# frozen_string_literal: true

class Resource < ApplicationRecord
  default_scope { order(name: :asc) }
  has_many :reservations, dependent: :destroy
  has_many :resource_questions, dependent: :destroy
  has_many :questions, through: :resource_questions
end
