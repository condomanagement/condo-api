# frozen_string_literal: true
# typed: true

class WebauthnCredentialsController < ActionController::API
  before_action :authenticate_user!, except: [:authentication_options, :authenticate, :check_availability]
  before_action :set_user_by_email, only: [:authentication_options]
  before_action :set_user_from_token, only: [:registration_options]
  before_action :set_credential, only: [:destroy]

  # GET /webauthn/registration_options
  # Generate options for registering a new passkey
  # rubocop:disable Metrics/MethodLength
  def registration_options
    return render json: { error: "User not found" }, status: :not_found unless @user

    # Create WebAuthn challenge for registration
    options = WebAuthn::Credential.options_for_create(
      user: {
        id: WebAuthn.generate_user_id,
        name: @user.email,
        display_name: @user.name
      },
      exclude: @user.webauthn_credentials.pluck(:external_id),
      authenticator_selection: {
        authenticator_attachment: "platform", # Prefer platform authenticators (Touch ID, Face ID, Windows Hello)
        resident_key: "preferred", # Support discoverable credentials
        user_verification: "preferred"
      }
    )

    # Store challenge in session for verification
    session[:webauthn_registration_challenge] = options.challenge

    render json: options
  end
  # rubocop:enable Metrics/MethodLength

  # POST /webauthn/register
  # Complete passkey registration
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def register
    user = User.user_by_token(request.cookies["token"])
    return render json: { error: "Unauthorized" }, status: :unauthorized unless user

    begin
      webauthn_credential = WebAuthn::Credential.from_create(params[:credential])

      # Verify the credential
      webauthn_credential.verify(session[:webauthn_registration_challenge])

      # Save the credential
      credential = user.webauthn_credentials.create!(
        external_id: webauthn_credential.id,
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count,
        nickname: params[:nickname] || "Passkey #{user.webauthn_credentials.count + 1}",
        transports: params[:credential][:response][:transports]&.to_json
      )

      # Clear the challenge
      session.delete(:webauthn_registration_challenge)

      render json: {
        success: true,
        credential: {
          id: credential.id,
          nickname: credential.nickname,
          created_at: credential.created_at
        }
      }
    rescue WebAuthn::Error => e
      render json: { error: "Registration failed: #{e.message}" }, status: :unprocessable_content
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # GET /webauthn/authentication_options
  # Generate options for passkey authentication
  # Supports both email-based and usernameless authentication
  def authentication_options
    if params[:email].present?
      # Email-based authentication
      return render json: { error: "User not found" }, status: :not_found unless @user

      unless @user.passkeys_enabled?
        return render json: { error: "No passkeys registered", passkeys_available: false },
                      status: :not_found
      end
    end

    options = build_authentication_options
    session[:webauthn_authentication_challenge] = options.challenge

    render json: options.as_json.merge(passkeys_available: true)
  end

  # POST /webauthn/authenticate
  # Complete passkey authentication
  def authenticate
    webauthn_credential = WebAuthn::Credential.from_get(params[:credential])
    stored_credential = find_and_verify_credential(webauthn_credential)

    return render json: { error: "Credential not found" }, status: :not_found unless stored_credential

    authentication = create_authentication_token(stored_credential)
    session.delete(:webauthn_authentication_challenge)

    render json: {
      success: true,
      token: authentication.token,
      user: format_user(stored_credential.user)
    }
  rescue WebAuthn::Error => e
    render json: { error: "Authentication failed: #{e.message}" }, status: :unauthorized
  end

  # GET /webauthn/credentials
  # List all passkeys for current user
  def index
    user = User.user_by_token(request.cookies["token"])
    return render json: { error: "Unauthorized" }, status: :unauthorized unless user

    credentials = user.webauthn_credentials.map do |cred|
      {
        id: cred.id,
        nickname: cred.nickname,
        created_at: cred.created_at,
        last_used_at: cred.last_used_at,
        credential_type: cred.credential_type
      }
    end

    render json: { credentials: credentials }
  end

  # DELETE /webauthn/credentials/:id
  # Remove a passkey
  def destroy
    @credential.destroy
    render json: { success: true }
  end

  # GET /webauthn/check_availability
  # Check if user has passkeys available
  def check_availability
    return render json: { error: "Email required" }, status: :bad_request unless params[:email]

    user = User.find_by("LOWER(email) = ?", params[:email].downcase)
    return render json: { passkeys_available: false } unless user

    render json: {
      passkeys_available: user.passkeys_enabled?,
      passkey_count: user.webauthn_credentials.count
    }
  end

private

  def authenticate_user!
    user = User.user_by_token(request.cookies["token"])
    render json: { error: "Unauthorized" }, status: :unauthorized unless user
  end

  def set_user_by_email
    @user = User.find_by("LOWER(email) = ? AND active = true", params[:email]&.downcase)
  end

  def set_user_from_token
    @user = User.user_by_token(request.cookies["token"])
  end

  def set_credential
    user = User.user_by_token(request.cookies["token"])
    return render json: { error: "Unauthorized" }, status: :unauthorized unless user

    @credential = user.webauthn_credentials.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Credential not found" }, status: :not_found
  end

  # Build WebAuthn options for authentication
  def build_authentication_options
    # For usernameless auth, allow any credential (discoverable credentials)
    # For email-based auth, restrict to user's credentials
    options = {
      user_verification: "preferred"
    }
    
    if @user.present?
      options[:allow] = @user.webauthn_credentials.pluck(:external_id)
    end
    
    WebAuthn::Credential.options_for_get(**options)
  end

  # Find and verify the credential
  def find_and_verify_credential(webauthn_credential)
    stored_credential = WebauthnCredential.find_by(external_id: webauthn_credential.id)
    return nil unless stored_credential

    # Verify the credential
    webauthn_credential.verify(
      session[:webauthn_authentication_challenge],
      public_key: stored_credential.public_key,
      sign_count: stored_credential.sign_count
    )

    # Update sign count and last used timestamp
    stored_credential.update_usage!(webauthn_credential.sign_count.to_i)

    stored_credential
  end

  # Create authentication token for the user
  def create_authentication_token(credential)
    credential.user.authentications.create!(
      emailtoken: "passkey:#{credential.external_id}",
      token: SecureRandom.hex(32),
      used: false
    )
  end

  def format_user(user)
    {
      active: user.active,
      admin: user.admin,
      email: user.email,
      id: user.id,
      name: user.name,
      parkingAdmin: user.parking_admin,
      phone: user.phone,
      unit: user.unit,
      type: user.resident_type,
      vaccinated: user.vaccinated
    }
  end
end
