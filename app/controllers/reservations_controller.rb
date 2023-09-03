# frozen_string_literal: true

class ReservationsController < ActionController::API
  before_action :set_reservation, only: [:update, :destroy]

  # GET /reservations
  # GET /reservations.json
  def index
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end

    @reservations = prep_reservation
    render json: @reservations, status: :ok
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @user = User.user_by_token(request.cookies["token"])
    return unless valid_form?

    @reservation = Reservation.new(reservation_params)
    @reservation.user = @user

    render json: { error: "The time selected is not available." }, status: :unauthorized and return unless valid_time?
    render json: { error: "Reservation time too long." }, status: :unauthorized and return false unless valid_length?
    unless valid_vaccine?
      render json: { error: "You must be vaccinated to use this amenity." }, status: :unauthorized and return false
    end

    save_reservation
  end

  def valid_form?
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user

    if params[:reservation][:resource_id] == "null"
      render json: { error: "Please selesct an amenity." }, status: :unauthorized
      return false
    end

    render json: { error: "Please answer all questions." }, status: :unauthorized and return false unless valid_answers?

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
    @user = User.user_by_token(request.cookies["token"])
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user

    if @reservation.update(reservation_params)
      render json: @reservation, status: :ok
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  def find_reservations
    @user = User.user_by_token(request.cookies["token"])
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user
    unless params[:date] || params[:resource]
      render json: { error: "Bad query" }, status: :unprocessable_entity and return
    end

    @reservations = query_reservations
    render json: @reservations, status: :ok
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @user = User.user_by_token(request.cookies["token"])
    return if @user != @reservation.user

    @reservation.destroy
    head :no_content
  end

  def mine
    @user = User.user_by_token(request.cookies["token"])
    render json: { error: "invalid_token" }, status: :unauthorized and return false unless @user

    @my_reservations = Reservation.where(user: @user).map do |r|
      {
        id: r.id,
        startTime: r.start_time,
        endTime: r.end_time,
        amenity: r.resource.name
      }
    end

    render json: @my_reservations, status: :ok
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
    @questions = Resource.find(params[:reservation][:resource_id]).questions
    @questions.each do |q|
      return false unless JSON.parse(params[:answers][0])[q.id]
    end

    true
  end

  def valid_time?
    start_time = Time.zone.parse(params[:reservation][:start_time])
    end_time = Time.zone.parse(params[:reservation][:end_time])
    query_valid_time(start_time, end_time)
  end

  def valid_vaccine?
    vaccine_required = Resource.find(params[:reservation][:resource_id]).vaccine
    return true unless vaccine_required

    user_vaccinated = @user.vaccinated
    return true if user_vaccinated

    false
  end

  def query_valid_time(start_time, end_time)
    Reservation.where("(start_time, end_time) OVERLAPS (?, ?) AND resource_id = ?",
                      start_time,
                      end_time,
                      params[:reservation][:resource_id]).empty?
  end

  def valid_length?
    @resource = Resource.find(params[:reservation][:resource_id])
    return false if time_diff > @resource.time_limit

    true
  end

  def time_diff
    start_time = Time.zone.parse(params[:reservation][:start_time])
    end_time = Time.zone.parse(params[:reservation][:end_time])
    (end_time - start_time) / 60
  end

  def prep_reservation
    @reservations = Reservation.all.map do |r|
      {
        id: r.id,
        endTime: r.end_time,
        startTime: r.start_time,
        amenity: r.resource.name,
        userName: r.user.name,
        userEmail: r.user.email
      }
    end
  end

  def to_local_date(date)
    DateTime.parse(date).localtime
  end

  def query_reservations
    @reservations = Reservation.select(:id, :start_time, :end_time).where(
      [
        "resource_id = ? and start_time >= ? and end_time <= ?",
        params[:resource],
        to_local_date(params[:startDay]),
        to_local_date(params[:endDay]).end_of_day
      ]
    )
    map_reservations(@reservations)
  end

  def map_reservations(reservations)
    reservations.map do |r|
      {
        id: r.id,
        startTime: r.start_time,
        endTime: r.end_time
      }
    end
  end
end
