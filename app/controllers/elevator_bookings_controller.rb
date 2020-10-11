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

    @bookings = prep_bookings
    render json: @bookings, status: :ok
  end

  # POST /elevator_bookings
  # POST /elevator_bookings.json
  def create
    @user = User.user_by_token(request.cookies["token"])
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user

    @elevator_booking = ElevatorBooking.new(elevator_booking_params)
    @elevator_booking.approved = false
    @elevator_booking.user = @user

    if @elevator_booking.save
      send_new_emails
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

  # PATCH/PUT /elevator_bookings/approve/1
  def approve
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @elevator_booking = ElevatorBooking.find(params[:id])
    @elevator_booking.approved = true

    @elevator_booking.save
    ElevatorMailer.approval(@elevator_booking).deliver_later
    render json: @elevator_booking, status: :ok
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_elevator_booking
    @elevator_booking = ElevatorBooking.find(params[:id])
  end

  def send_new_emails
    ElevatorMailer.pending(@elevator_booking).deliver_later
    ElevatorMailer.notification(@elevator_booking).deliver_later
  end

  def prep_bookings
    @elevator_bookings = ElevatorBooking.all.map do |b|
      {
        id: b.id, endTime: b.end, startTime: b.start, unit: b.unit,
        name1: b.name1, name2: b.name2, user: b.user,
        phoneDay: b.phone_day, phoneNight: b.phone_night, deposit: b.deposit,
        moveType: b.moveType, approved: b.approved, moveIn: b.in, moveOut: b.out
      }
    end
  end

  # Only allow a list of trusted parameters through.
  def elevator_booking_params
    params.require(:elevator_booking).permit(
      :user_id, :start, :end, :unit, :ownerType, :name1, :name2,
      :phone_day, :phone_night, :deposit, :moveType, :approved,
      :in, :out
    )
  end
end
