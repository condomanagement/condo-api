# frozen_string_literal: true

class User < ApplicationRecord
  default_scope { order(unit: :asc) }
  validates :unit, presence: true, numericality: { only_integer: true }
  has_many :authentications, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :elevator_bookings, dependent: :destroy
  has_many :webauthn_credentials, dependent: :destroy

  # Check if user has any passkeys registered
  def passkeys_enabled?
    webauthn_credentials.exists?
  end

  # Get all passkeys for management UI
  def passkey_list
    webauthn_credentials.select(:id, :nickname, :created_at, :last_used_at, :credential_type)
  end

  def self.admin_by_token?(token)
    @authentication = Authentication.find_by(token:)
    return false unless @authentication

    return true if @authentication.user[:admin] && @authentication.user[:active]

    false
  end

  def self.parking_admin_by_token?(token)
    @authentication = Authentication.find_by(token:)
    return false unless @authentication

    return true if @authentication.user[:parking_admin] && @authentication.user[:active]

    false
  end

  def self.user_by_token(token)
    @authentication = Authentication.find_by(token:)
    return false unless @authentication&.user&.active

    @authentication.user
  end
end
