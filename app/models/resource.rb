# frozen_string_literal: true

class Resource < ApplicationRecord
  default_scope { order(name: :asc) }
  has_many :reservations, dependent: :destroy
end
