# frozen_string_literal: true

# lib/databridge_shared/auth/jwt_helper.rb
require "jwt"

module DataBridgeShared
  module Auth
    # Provides helper methods for JWT token generation and verification
    # Used for authentication and authorization across DataBridge services
    class JwtHelper
      def self.encode(payload, secret, algorithm = "HS256")
        JWT.encode(payload, secret, algorithm)
      end

      def self.decode(token, secret, algorithm = "HS256")
        JWT.decode(token, secret, true, { algorithm: algorithm })
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
