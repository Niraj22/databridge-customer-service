module JwtConfig
    class << self
      def secret_key
        Rails.application.credentials.jwt_secret_key
      end
    end
end