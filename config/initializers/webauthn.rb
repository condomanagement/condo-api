# frozen_string_literal: true

# WebAuthn configuration initializer
WebAuthn.configure do |config|
  # This value needs to match your website domain
  config.allowed_origins = [
    ENV.fetch("WEBAUTHN_ORIGIN", "http://localhost:3000"),
    ENV.fetch("WEBAUTHN_ORIGIN_ADDITIONAL", nil)
  ].compact
  
  # Relying party name for display purposes
  config.rp_name = ENV.fetch("WEBAUTHN_RP_NAME", "Condo Management")
  
  # Optional: Relying party ID (defaults to origin's domain)
  # config.rp_id = ENV.fetch("WEBAUTHN_RP_ID", "localhost")
  
  # Credential options timeout (in milliseconds)
  config.credential_options_timeout = 120_000
  
  # Algorithms for credentials
  config.algorithms = ["ES256", "PS256", "RS256"]
end
