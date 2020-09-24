# frozen_string_literal: true

class ElevatorBookingsController < ActionController::API
  before_action :set_elevator_booking, only: [:show, :edit, :update, :destroy]

  # GET /elevator_bookings/1
  # GET /elevator_bookings/1.json
  def index
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @bookings = ElevatorBooking.all.order("created_at DESC")
    render json: @bookings, status: :ok
  end

  # POST /elevator_bookings
  # POST /elevator_bookings.json
  def create
    @user = User.user_by_token(request.cookies["token"])
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user

    @elevator_booking = ElevatorBooking.new(elevator_booking_params)

    if @elevator_booking.save
      render json: @elevator_booking, status: :created
    else
      render json: @elevator_booking.errors, status: :unprocessable_entity
    end
  end

  # DELETE /elevator_bookings/1
  # DELETE /elevator_bookings/1.json
  def destroy
    @user = User.user_by_token(request.cookies["token"])
    return if @user != @elevator_booking.user

    @elevator_booking.destroy
    head :no_content
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_elevator_booking
    @elevator_booking = ElevatorBooking.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def elevator_booking_params
    params.require(:elevator_booking).permit(
      :user_id,
      :start,
      :end,
      :unit,
      :ownerType,
      :name1,
      :name2,
      :phone_day,
      :phone_night,
      :deposit,
      :moveType
    )
  end
end
