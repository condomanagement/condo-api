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
      render json: { error: @parking.errors.full_messages.first }, status: :unauthorized
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

    @it_today = prep_parking(@today)

    render json: @it_today
  end

  def past
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @past = Parking.past
    @the_past = prep_parking(@past)

    render json: @the_past
  end

  def future
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @future = Parking.future

    @the_future = prep_parking(@future)

    render json: @the_future
  end

private

  def parking_params
    params.require(:parking).permit(:code, :unit, :make, :color, :license, :start_date, :end_date, :contact)
  end

  def prep_parking(parking)
    parking.map do |p|
      {
        id: p.id,
        make: p.make,
        contact: p.contact,
        license: p.license,
        color: p.color,
        startDate: p.start_date,
        endDate: p.end_date,
        unit: p.unit
      }
    end
  end
end
