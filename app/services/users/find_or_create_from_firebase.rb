# frozen_string_literal: true

module Users
  class FindOrCreateFromFirebase
    def self.call(payload)
      new(payload).call
    end

    def initialize(payload)
      @payload = payload
    end

    def call
      user = User.find_or_initialize_by(firebase_uid: payload["sub"])
      user.email = payload["email"]
      user.name = payload["name"].presence || payload["email"].to_s.split("@").first
      user.avatar_url = payload["picture"] if payload["picture"].present?
      user.save!
      user
    end

    private

    attr_reader :payload
  end
end
