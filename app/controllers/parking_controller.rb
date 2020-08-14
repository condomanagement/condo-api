# frozen_string_literal: true

class ParkingController < ActionController::API
  def index
    @parking = Parking.new
    render json: @parking
  end

  def create
    @parking = Parking.new(parking_params)
    if @parking.save
      ParkingMailer.registration(@parking).deliver_later
      ParkingMailer.confirmation(@parking).deliver_later if EmailValidator.valid?(@parking[:contact])
      response = { success: true }
    else
      render json: { error: "You did not fill out the entire form, or the lot is full." }, status: :unauthorized
      return
    end
    render json: response
  end

  def today
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @today = Parking.today

    render json: @today
  end

  def past
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @past = Parking.past

    render json: @past
  end

  def future
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @future = Parking.future

    render json: @future
  end

  def registered; end

  def terms; end

private

  def parking_params
    params.require(:parking).permit(:code, :unit, :make, :color, :license, :start_date, :end_date, :contact)
  end
end
