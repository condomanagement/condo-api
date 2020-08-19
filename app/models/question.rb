# frozen_string_literal: true

class Question < ApplicationRecord
  default_scope { order(question: :asc) }
end
