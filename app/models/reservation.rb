# frozen_string_literal: true
# typed: strict

class Reservation < ApplicationRecord
  default_scope { order(start_time: :desc) }
  belongs_to :user
  belongs_to :resource
end
