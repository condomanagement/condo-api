# frozen_string_literal: true

class User < ApplicationRecord
  validates :unit, presence: true, numericality: { only_integer: true }
  has_many :authentications, dependent: :destroy
  has_many :reservations, dependent: :destroy
end
