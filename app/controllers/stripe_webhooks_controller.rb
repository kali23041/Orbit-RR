class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig = request.env["HTTP_STRIPE_SIGNATURE"]
    secret = Rails.application.config.x.stripe.webhook_secret

    event = if secret.present?
      Stripe::Webhook.construct_event(payload, sig, secret)
    else
      Stripe::Event.construct_from(JSON.parse(payload))
    end

    case event.type
    when "checkout.session.completed"
      session = event.data.object
      booking = Booking.find_by(stripe_checkout_session_id: session.id)
      if booking&.pending_payment?
        booking.update!(stripe_payment_intent_id: session.payment_intent)
        booking.confirm!
      end
    end

    head :ok
  rescue JSON::ParserError, Stripe::SignatureVerificationError
    head :bad_request
  end
end
