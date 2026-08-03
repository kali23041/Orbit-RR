class BookingNotesController < ApplicationController
  before_action :require_authentication

  def create
    booking = Booking.find(params[:booking_id])
    note = booking.booking_notes.new(body: params.require(:booking_note)[:body], author: current_user)
    authorize note

    if note.save
      redirect_to booking_room_path(booking), notice: "Note saved."
    else
      redirect_to booking_room_path(booking), alert: note.errors.full_messages.to_sentence
    end
  end
end
