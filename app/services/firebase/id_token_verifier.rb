# frozen_string_literal: true

module Firebase
  # https://firebase.google.com/docs/auth/admin/verify-id-tokens
  class IdTokenVerifier
    CERTS_URL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    CACHE_KEY = "firebase/id_token_certs"
    CACHE_TTL = 1.hour

    class Error < StandardError; end
    class InvalidToken < Error; end

    def self.verify!(token)
      new.verify!(token)
    end

    def verify!(token)
      raise InvalidToken, "ID token is blank" if token.blank?

      project_id = Rails.application.config.x.firebase.project_id
      raise Error, "FIREBASE_PROJECT_ID is not configured" if project_id.blank?

      payload, = JWT.decode(token, nil, true, {
        algorithms: [ "RS256" ],
        iss: "https://securetoken.google.com/#{project_id}",
        aud: project_id,
        verify_iss: true,
        verify_aud: true,
        verify_iat: true,
        verify_expiration: true
      }) do |header|
        certificate_for(header["kid"])
      end

      raise InvalidToken, "Missing subject" if payload["sub"].blank?
      raise InvalidToken, "Missing email" if payload["email"].blank?

      payload
    rescue JWT::DecodeError => e
      raise InvalidToken, e.message
    end

    private

    def certificate_for(kid)
      certs = Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_TTL) do
        response = HTTParty.get(CERTS_URL, timeout: 5)
        raise Error, "Unable to fetch Firebase certs" unless response.success?

        response.parsed_response
      end

      pem = certs[kid]
      raise InvalidToken, "Unknown certificate kid" if pem.blank?

      OpenSSL::X509::Certificate.new(pem).public_key
    end
  end
end
