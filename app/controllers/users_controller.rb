# frozen_string_literal: true

class UsersController < ActionController::API
  include Pagy::Backend

  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if params[:page] || params[:items]
      page = params[:page] || 1
      items = params[:items] || 25

      pagy, users = pagy(User.all, page: page, items: items)

      @users = users.map do |u|
        format_user(u)
      end

      render json: {
        users: @users,
        pagy: pagy_metadata(pagy)
      }, status: :ok
    else
      @users = User.all.map do |u|
        format_user(u)
      end
      render json: @users, status: :ok
    end
  end

  # GET /users/1
  def show
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
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
      render json: @user.errors, status: :unprocessable_content
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
      render json: @user.errors, status: :unprocessable_content
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
    return unless authorized_for_upload?

    begin
      @result = users_object
      create_users_from_upload
    rescue JSON::ParserError
      render json: { error: "invalid_json" }, status: :unprocessable_content
    end
  end

  def users_object
    @result = JSON.parse params[:file].tempfile.read if params[:file]
    @result = JSON.parse request.parameters[:body] unless params[:file]
    @result
  end

  # rubocop:disable Naming/PredicateMethod
  def new_user(person)
    return false if person &&
                    person["unit"] &&
                    person["email"] &&
                    User.find_by(unit: person["unit"], email: person["email"])

    true
  end
  # rubocop:enable Naming/PredicateMethod

private

  def create_users_from_upload
    saved = true
    ActiveRecord::Base.transaction do
      @result.each do |person|
        User.create!(person) if new_user(person)
      end
    rescue ActiveRecord::RecordInvalid
      saved = false
      render json: { error: "missing_required_fields" }, status: :unprocessable_content
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

  def authorized_for_upload?
    return authorized_token? if request.headers["X-Administrative-Token"].present?

    authorized_admin?
  end

  def authorized_token?
    if request.headers["X-Administrative-Token"] == ENV["ADMINISTRATIVE_TOKEN"]
      true
    else
      render json: { error: "invalid_token" }, status: :unprocessable_content
      false
    end
  end

  def authorized_admin?
    if admin?
      true
    else
      render json: { error: "unauthorized" }, status: :unprocessable_content
      false
    end
  end

  def admin?
    return false unless request.cookies["token"]

    @authentication = Authentication.find_by(token: request.cookies["token"])
    return false unless @authentication&.user
    return false unless @authentication.user.admin == true
    return false unless @authentication.user.active == true

    true
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params
      .expect(user: [:name, :unit, :email, :phone, :active, :admin, :parking_admin, :resident_type, :vaccinated])
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
