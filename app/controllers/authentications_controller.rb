# frozen_string_literal: true

class AuthenticationsController < ActionController::API
  def valid
    @authentication = Authentication.find_by(token: params[:token])
    @user = format_user(@authentication.user) if @authentication&.user
    render json: { success: true, user: @user } if @authentication && @user&.active
    render json: { success: false, error: "invalid_email" } unless @authentication
  end

  def login
    @user = User.where("LOWER(email) = ? AND active = true", params[:email].downcase).first
    if @user
      @authentication = Authentication.new(
        emailtoken: SecureRandom.uuid,
        token: SecureRandom.uuid,
        user: @user
      )
      @authentication.save
      AuthenticationMailer.registration(@authentication).deliver_later
      render json: { success: true }
    else
      render json: { error: "invalid_email" }
    end
  end

  def process_login
    @authentication = Authentication.find_by(emailtoken: params[:emailKey])
    if @authentication
      render json: { success: true, token: @authentication.token }
    else
      render json: { success: false }
    end
  end

  def logout
    @authentication = Authentication.find_by(token: params[:token])
    if @authentication
      @authentication.delete
      render json: { success: true }
    else
      render json: { success: false, error: "invalid_token" }
    end
  end

private

  def set_authentication
    @authentication = Authentication.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def authentication_params
    params.require(:authentication).permit(:user_id, :emailtoken, :token)
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
      unit: user.unit
    }
  end
end
