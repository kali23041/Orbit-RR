class SessionRoomsController < ApplicationController
  before_action :require_authentication

  def show
    @booking = Booking.find(params[:booking_id])
    authorize @booking, :show?
    @firebase_config = Rails.application.config.x.firebase.client_config
    @notes = @booking.booking_notes.includes(:author).order(created_at: :desc)
    @room_payload = {
      roomId: @booking.firestore_room_id.delete_prefix("bookings/"),
      firestorePath: @booking.firestore_room_id,
      learnerUid: @booking.learner.firebase_uid,
      mentorUid: @booking.mentor_user.firebase_uid,
      currentUid: current_user.firebase_uid,
      displayName: current_user.display_name,
      bookingStatus: @booking.status
    }
  end
end
