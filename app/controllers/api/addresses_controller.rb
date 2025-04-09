module Api
    class AddressesController < ApplicationController
      before_action :set_customer
      before_action :set_address, only: [:show, :update, :destroy]
      before_action :authorize_owner_or_admin
  
      def index
        addresses = @customer.addresses
        render json: addresses
      end
  
      def show
        render json: @address
      end
  
      def create
        address = @customer.addresses.new(address_params)
        
        if address.save
          render json: address, status: :created
        else
          render json: { errors: address.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      def update
        if @address.update(address_params)
          render json: @address
        else
          render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      def destroy
        @address.destroy
        head :no_content
      end
  
      private
  
      def set_customer
        @customer = Customer.find(params[:customer_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Customer not found' }, status: :not_found
      end
  
      def set_address
        @address = @customer.addresses.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Address not found' }, status: :not_found
      end
  
      def address_params
        params.permit(:address_type, :street, :city, :state, :postal_code, :country, :is_default)
      end
  
      def authorize_owner_or_admin
        unless current_user && (current_user.id == @customer.id || current_user.admin?)
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
    end
  end