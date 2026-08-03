# frozen_string_literal: true

module Payments
  class CreateCheckoutSession
    def self.call(booking:, success_url:, cancel_url:)
      new(booking:, success_url:, cancel_url:).call
    end

    def initialize(booking:, success_url:, cancel_url:)
      @booking = booking
      @success_url = success_url
      @cancel_url = cancel_url
    end

    def call
      raise "STRIPE_SECRET_KEY is not configured" if Stripe.api_key.blank?

      session = Stripe::Checkout::Session.create(
        mode: "payment",
        customer_email: booking.learner.email,
        line_items: [ {
          quantity: 1,
          price_data: {
            currency: booking.currency,
            unit_amount: booking.amount_cents,
            product_data: {
              name: "Orbit session with #{booking.mentor_user.display_name}",
              description: booking.mentor_profile.headline
            }
          }
        } ],
        metadata: { booking_id: booking.id },
        success_url: success_url,
        cancel_url: cancel_url
      )

      booking.update!(stripe_checkout_session_id: session.id)
      session
    end

    private

    attr_reader :booking, :success_url, :cancel_url
  end
end
