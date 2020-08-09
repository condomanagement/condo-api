# frozen_string_literal: true

class AdminController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def index
    @today = Parking.today
    @future = Parking.future
    @past = Parking.past
    @all = Parking.all
  end

  def destroy
    @registration = Parking.find(params[:id])
    @registration.destroy

    redirect_to admin_path
  end

  def show
    @registration = Parking.find(params[:id])
  end

  def simple
    @today = Parking.today

    render "simple", layout: "simple"
  end
end
