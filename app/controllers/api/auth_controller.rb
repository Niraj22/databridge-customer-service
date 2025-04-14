module Api
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:login, :register]
  
      def login
        customer = Customer.find_by(email: params[:email])
        kafka_config = Rails.application.credentials.kafka
      
        begin
          if customer&.authenticate(params[:password])
            customer.update(last_login_at: Time.current)
      
            publish_event('user.login.success', {
              user_id: customer.id,
              timestamp: Time.current.iso8601
            }, kafka_config)
      
            render json: { user: customer }, status: :ok
          else
            publish_event('user.login.failed', {
              email: params[:email],
              timestamp: Time.current.iso8601
            }, kafka_config) if params[:email].present?
      
            render json: { error: 'Invalid credentials' }, status: :unauthorized
          end
        rescue => e
          Rails.logger.error("Login error: #{e.message}")
          render json: { error: 'Something went wrong' }, status: :internal_server_error
        end
      end
      
  
      def register
        customer = Customer.new(customer_params)
        
        if customer.save
          token = generate_token(customer)
          customer.publish_created_event
          
          render json: { token: token, user: customer_response(customer) }, status: :created
        else
          render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      private
  
      def customer_params
        params.permit(:email, :password, :name, :role)
      end
  
      def customer_response(customer)
        {
          id: customer.id,
          email: customer.email,
          name: customer.name,
          role: customer.role,
          status: customer.status,
          created_at: customer.created_at
        }
      end
  
      def generate_token(customer)
        payload = {
          user_id: customer.id,
          email: customer.email,
          roles: [customer.role],
          exp: 24.hours.from_now.to_i
        }
        
        DataBridgeShared::Auth::JwtHelper.encode(payload, auth_secret)
      end
  
      def auth_secret
        Rails.application.credentials.secret_key_base
      end

      def publish_event(event_name, payload, kafka_config)
        DataBridgeShared::Clients::EventPublisher.new(
          seed_brokers: kafka_config[:brokers],
          client_id: kafka_config[:client_id]
        ).publish(event_name, payload)
      end
    end
  end