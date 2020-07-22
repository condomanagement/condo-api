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
      redirect_to registered_path
      ParkingMailer.confirmation(@parking).deliver_later if EmailValidator.valid?(@parking[:contact])
    else
      render action: "index"
    end
  end

  def registered; end

  def terms; end

private

  def parking_params
    params.require(:parking).permit(:code, :unit, :make, :color, :license, :start_date, :end_date, :contact)
  end
end
