class SessionRoomsController < ApplicationController
  before_action :require_authentication

  def show
    @booking = Booking.find(params[:booking_id])
    authorize @booking, :show?
    @firebase_config = Rails.application.config.x.firebase.client_config
  end
end
