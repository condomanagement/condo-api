# frozen_string_literal: true

class Resource < ApplicationRecord
  has_many :reservations, dependent: :destroy
end
