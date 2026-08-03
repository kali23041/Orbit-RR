# frozen_string_literal: true

module Bookings
  class Cancel
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
      raise Error, "Booking cannot be cancelled" unless booking.cancellable?

      booking.cancel!
      notify_counterpart!
      booking
    end

    private

    attr_reader :booking, :actor

    def notify_counterpart!
      counterpart = actor.id == booking.learner_id ? booking.mentor_user : booking.learner
      Notifications::Notify.call(
        user: counterpart,
        kind: "booking_cancelled",
        title: "Session cancelled",
        body: "#{actor.display_name} cancelled the session.",
        link_path: "/bookings/#{booking.id}"
      )
      BookingMailer.cancelled(booking).deliver_later
    end
  end
end
