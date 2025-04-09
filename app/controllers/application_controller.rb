class ApplicationController < ActionController::API
    before_action :authenticate_request
    
    private
    
    def authenticate_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      
      begin
        # Use the shared secret for decoding
        decoded = DataBridgeShared::Auth::JwtHelper.decode(header,Rails.application.credentials.jwt_secret_key)
        
        # Extract user details from token
        payload = decoded&.first
        @current_user = Customer.find(payload['user_id']) if payload
        
        # Store the user's role from the token
        @current_user_role = payload['role'] if payload
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

    def current_user
      @current_user
    end

    def current_user_role
      @current_user_role
    end
end