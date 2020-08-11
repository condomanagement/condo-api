# frozen_string_literal: true

class User < ApplicationRecord
  validates :unit, presence: true, numericality: { only_integer: true }
  has_many :authentications, dependent: :destroy
  has_many :reservations, dependent: :destroy

  def self.admin_by_token?(token)
    @authentication = Authentication.find_by(token: token)
    return false unless @authentication

    return true if @authentication.user[:admin]

    false
  end
end
