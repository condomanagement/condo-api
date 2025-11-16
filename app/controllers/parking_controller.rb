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
    unless parking_authorized?
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if paginated?
      render_paginated_parking(Parking.today)
    else
      render json: prep_parking(Parking.today)
    end
  end

  def past
    unless parking_authorized?
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if paginated?
      render_paginated_parking(Parking.past)
    else
      render json: prep_parking(Parking.past)
    end
  end

  def future
    unless parking_authorized?
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    if paginated?
      render_paginated_parking(Parking.future)
    else
      render json: prep_parking(Parking.future)
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

  def paginated?
    params[:page] || params[:items]
  end

  def parking_authorized?
    User.admin_by_token?(request.cookies["token"]) || User.parking_admin_by_token?(request.cookies["token"])
  end

  def render_paginated_parking(scope)
    page = params[:page] || 1
    items = params[:items] || 25
    pagy, records = pagy(scope, page: page, items: items)

    render json: { parking: prep_parking(records), pagy: pagy_metadata(pagy) }
  end
end
