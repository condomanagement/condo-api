# frozen_string_literal: true

class ElevatorBookingsController < ActionController::API
  before_action :set_elevator_booking, only: [:destroy]

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
    return unless valid_form?

    @elevator_booking = ElevatorBooking.new(elevator_booking_params)
    @elevator_booking.approved = false
    @elevator_booking.status = "pending"
    @elevator_booking.user = @user

    save_elevator_booking
  end

  def valid_form?
    unless elevator_booking_params.key?(:name1)
      render json: { error: "Name is required" }, status: :unauthorized and return false
    end

    unless elevator_booking_params.key?(:unit)
      render json: { error: "Unit number is required" }, status: :unauthorized and return false
    end

    unless elevator_booking_params[:in] == "true" || elevator_booking_params[:out] == "true"
      render json: { error: "Please check at least one in/out option" }, status: :unauthorized
      return false
    end

    true
  end

  def save_elevator_booking
    if @elevator_booking.save
      send_new_emails
      render json: @elevator_booking, status: :created
    else
      render json: @elevator_booking.errors.full_messages, status: :unprocessable_entity
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
    @elevator_booking.status = true

    @elevator_booking.save
    ElevatorMailer.approval(@elevator_booking).deliver_later
    render json: @elevator_booking, status: :ok
  end

  def reject
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @elevator_booking = ElevatorBooking.find(params[:id])
    @elevator_booking.status = false
    @elevator_booking.rejection = elevator_booking_params[:rejection]

    @elevator_booking.save
    ElevatorMailer.rejection(@elevator_booking).deliver_later
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
        moveType: b.moveType, status: b.status, moveIn: b.in, moveOut: b.out,
        rejection: b.rejection
      }
    end
  end

  # Only allow a list of trusted parameters through.
  def elevator_booking_params
    params.require(:elevator_booking).permit(
      :user_id, :start, :end, :unit, :name1, :name2,
      :phone_day, :phone_night, :deposit, :moveType, :approved,
      :in, :out, :status, :rejection
    )
  end
end
