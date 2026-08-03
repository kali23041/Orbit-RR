# frozen_string_literal: true

module Bookings
  class Create
    class Error < StandardError; end

    def self.call(learner:, slot:, notes: nil)
      new(learner:, slot:, notes:).call
    end

    def initialize(learner:, slot:, notes: nil)
      @learner = learner
      @slot = slot
      @notes = notes
    end

    def call
      raise Error, "Slot is not available" unless slot.open? && slot.starts_at.future?
      raise Error, "You cannot book your own session" if slot.mentor_profile.user_id == learner.id

      Booking.transaction do
        booking = Booking.create!(
          learner: learner,
          mentor_profile: slot.mentor_profile,
          availability_slot: slot,
          amount_cents: slot.mentor_profile.hourly_rate_cents,
          currency: slot.mentor_profile.currency,
          notes: notes,
          meet_url: "https://meet.google.com/new",
          status: payment_required? ? :pending_payment : :confirmed
        )

        # Reserve the slot immediately to prevent double-booking.
        slot.booked!
        booking
      end
    end

    private

    attr_reader :learner, :slot, :notes

    def payment_required?
      Stripe.api_key.present?
    end
  end
end
