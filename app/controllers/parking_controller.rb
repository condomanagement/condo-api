# frozen_string_literal: true

class ParkingController < ActionController::API
  include Pagy::Backend

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
    unless User.admin_by_token?(request.cookies["token"]) || User.parking_admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if params[:page] || params[:items]
      page = params[:page] || 1
      items = params[:items] || 25

      pagy, today = pagy(Parking.today, page: page, items: items)
      @it_today = prep_parking(today)

      render json: {
        parking: @it_today,
        pagy: pagy_metadata(pagy)
      }
    else
      @today = Parking.today
      @it_today = prep_parking(@today)

      render json: @it_today
    end
  end

  def past
    unless User.admin_by_token?(request.cookies["token"]) || User.parking_admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if params[:page] || params[:items]
      page = params[:page] || 1
      items = params[:items] || 25

      pagy, past = pagy(Parking.past, page: page, items: items)
      @the_past = prep_parking(past)

      render json: {
        parking: @the_past,
        pagy: pagy_metadata(pagy)
      }
    else
      @past = Parking.past
      @the_past = prep_parking(@past)

      render json: @the_past
    end
  end

  def future
    unless User.admin_by_token?(request.cookies["token"]) || User.parking_admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if params[:page] || params[:items]
      page = params[:page] || 1
      items = params[:items] || 25

      pagy, future = pagy(Parking.future, page: page, items: items)
      @the_future = prep_parking(future)

      render json: {
        parking: @the_future,
        pagy: pagy_metadata(pagy)
      }
    else
      @future = Parking.future
      @the_future = prep_parking(@future)

      render json: @the_future
    end
  end

private

  def parking_params
    params.expect(parking: [:code, :unit, :make, :color, :license, :start_date, :end_date, :contact])
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
