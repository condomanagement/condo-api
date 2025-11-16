# frozen_string_literal: true
# typed: strict

class Authentication < ApplicationRecord
  belongs_to :user
end
