# frozen_string_literal: true

class ReservationsController < ActionController::API
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @reservations = Reservation.all
    render json: @questions, status: :ok
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @user = User.user_by_token(request.cookies["token"])
    return unless valid_form?

    @reservation = Reservation.new(reservation_params)
    @reservation.user = @user

    render json: { error: "The time selected is not available." }, status: :unauthorized and return unless valid_time?

    save_reservation
  end

  def valid_form?
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user
    render json: { error: "Please answer all questions." }, status: :unauthorized and return false unless valid_answers?

    if params[:reservation][:resource_id] == "null"
      render json: { error: "Please selesct an amenity." }, status: :unauthorized
      return false
    end

    true
  end

  def save_reservation
    if @reservation.save
      render json: @reservation, status: :created
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations/1.json
  def update
    if @reservation.update(reservation_params)
      render json: @reservation, status: :ok
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    head :no_content
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reservation_params
    params.require(:reservation).permit(:user_id, :resource_id, :start_time, :end_time, :resource_id)
  end

  def valid_answers?
    @questions = Question.all
    @questions.each do |q|
      return false unless JSON.parse(params[:answers][0])[q.id]
    end

    true
  end

  def valid_time?
    Reservation.where("(start_time, end_time) OVERLAPS (?, ?) AND resource_id = ?",
                      params[:reservation][:start_time].to_datetime,
                      params[:reservation][:end_time].to_datetime,
                      params[:reservation][:resource_id]).empty?
  end
end
