# frozen_string_literal: true
# typed: strict

class User < ApplicationRecord
  extend T::Sig

  default_scope { order(unit: :asc) }
  validates :unit, presence: true, numericality: { only_integer: true }
  has_many :authentications, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :elevator_bookings, dependent: :destroy
  has_many :webauthn_credentials, dependent: :destroy

  # Check if user has any passkeys registered
  sig { returns(T::Boolean) }
  def passkeys_enabled?
    webauthn_credentials.exists?
  end

  # Get all passkeys for management UI
  sig { returns(T.untyped) }
  def passkey_list
    webauthn_credentials.select(:id, :nickname, :created_at, :last_used_at, :credential_type)
  end

  sig { params(token: T.nilable(String)).returns(T::Boolean) }
  def self.admin_by_token?(token)
    return false if token.nil?

    authentication = Authentication.find_by(token: token)
    return false unless authentication&.user

    user = T.must(authentication.user)
    (user.admin && user.active) || false
  end

  sig { params(token: T.nilable(String)).returns(T::Boolean) }
  def self.parking_admin_by_token?(token)
    return false if token.nil?

    authentication = Authentication.find_by(token: token)
    return false unless authentication&.user

    user = T.must(authentication.user)
    (user.parking_admin && user.active) || false
  end

  sig { params(token: T.nilable(String)).returns(T.nilable(User)) }
  def self.user_by_token(token)
    return nil if token.nil?

    authentication = Authentication.find_by(token: token)
    return nil unless authentication

    user = authentication.user
    return nil unless user&.active

    user
  end
end
