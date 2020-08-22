# frozen_string_literal: true

class AdminController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def index
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @today = Parking.today
    @future = Parking.future
    @past = Parking.past
    @all = Parking.all
  end

  def destroy
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @registration = Parking.find(params[:id])
    @registration.destroy

    redirect_to admin_path
  end

  def show
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @registration = Parking.find(params[:id])
  end

  def simple
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @today = Parking.today

    render "simple", layout: "simple"
  end
end
