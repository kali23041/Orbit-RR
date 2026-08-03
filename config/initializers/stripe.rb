# frozen_string_literal: true

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

Rails.application.configure do
  config.x.stripe.publishable_key = ENV.fetch("STRIPE_PUBLISHABLE_KEY", "")
  config.x.stripe.webhook_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET", "")
end
