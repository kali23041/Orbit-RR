class BookingsController < ApplicationController
  before_action :require_authentication
  before_action :set_booking, only: %i[show success]

  def create
    slot = AvailabilitySlot.bookable.find(params[:availability_slot_id])
    authorize slot.mentor_profile, :book?

    booking = Bookings::Create.call(
      learner: current_user,
      slot: slot,
      notes: params[:notes]
    )

    if Stripe.api_key.present?
      session = Payments::CreateCheckoutSession.call(
        booking: booking,
        success_url: success_booking_url(booking),
        cancel_url: mentor_url(booking.mentor_profile)
      )
      redirect_to session.url, allow_other_host: true
    else
      redirect_to booking_path(booking), notice: "Session booked. Chat is ready in the room."
    end
  rescue Bookings::Create::Error => e
    redirect_back fallback_location: mentors_path, alert: e.message
  end

  def show
    authorize @booking
  end

  def success
    authorize @booking
    @booking.confirm! if @booking.pending_payment?
    redirect_to booking_path(@booking), notice: "Payment received. Your session is confirmed."
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
