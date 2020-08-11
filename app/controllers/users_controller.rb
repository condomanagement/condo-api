# frozen_string_literal: true

class UsersController < ActionController::API
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/1
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @user.destroy
    render json: @user, status: :ok
  end

  # POST /upload
  def upload
    if valid_token?
      begin
        @result = users_object
        create_users_from_upload
      rescue JSON::ParserError
        render json: { error: "invalid_json" }, status: :unprocessable_entity
      end
    else
      render json: { error: "invalid_token" }, status: :unprocessable_entity
    end
  end

  def users_object
    @result = JSON.parse params[:file].tempfile.read if params[:file]
    @result = JSON.parse request.parameters[:body] unless params[:file]
    @result
  end

  def new_user(person)
    if person && person["unit"] && person["email"]
      return false if User.find_by(unit: person["unit"], email: person["email"])
    end

    true
  end

private

  def create_users_from_upload
    saved = true
    ActiveRecord::Base.transaction do
      @result.each do |person|
        User.create!(person) if new_user(person)
      end
    rescue ActiveRecord::RecordInvalid
      saved = false
      render json: { error: "missing_required_fields" }, status: :unprocessable_entity
    end
    render json: { success: true } if saved
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def valid_token?
    return true if request.headers["X-Administrative-Token"] == ENV["ADMINISTRATIVE_TOKEN"]
    return true if admin?

    false
  end

  def admin?
    return false unless request.cookies["token"]

    @authentication = Authentication.find_by(token: request.cookies["token"])
    return true if @authentication.user.admin

    false
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :unit, :email, :phone, :active, :admin)
  end
end
