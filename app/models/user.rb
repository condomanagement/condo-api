# frozen_string_literal: true

class User < ApplicationRecord
  validates :unit, presence: true, numericality: { only_integer: true }
end
