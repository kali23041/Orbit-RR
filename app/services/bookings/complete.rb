# frozen_string_literal: true

module Bookings
  class Complete
    class Error < StandardError; end

    def self.call(booking:, actor:)
      new(booking:, actor:).call
    end

    def initialize(booking:, actor:)
      @booking = booking
      @actor = actor
    end

    def call
      raise Error, "Not allowed" unless booking.participant?(actor)
      raise Error, "Booking is not confirmed" unless booking.confirmed?

      booking.complete!
      Notifications::Notify.call(
        user: booking.learner,
        kind: "booking_completed",
        title: "Session completed",
        body: "Leave a review for #{booking.mentor_user.display_name}.",
        link_path: "/bookings/#{booking.id}"
      )
      BookingMailer.completed(booking).deliver_later
      booking
    end

    private

    attr_reader :booking, :actor
  end
end
