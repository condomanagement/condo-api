# frozen_string_literal: true

class WebauthnCredential < ApplicationRecord
  belongs_to :user

  validates :external_id, presence: true, uniqueness: true
  validates :public_key, presence: true
  validates :sign_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Update the last used timestamp and sign count
  def update_usage!(new_sign_count)
    update!(
      sign_count: new_sign_count,
      last_used_at: Time.current
    )
  end

  # Serialize transports as JSON if needed
  serialize :transports, coder: JSON
end
