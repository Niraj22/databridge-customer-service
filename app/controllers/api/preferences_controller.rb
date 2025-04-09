module Api
  class PreferencesController < ApplicationController
    before_action :set_customer
    before_action :authorize_owner_or_admin
    before_action :set_preference, only: [:show, :destroy]

    # GET /api/customers/:customer_id/preferences
    def index
      preferences = @customer.preferences
      render json: preferences
    end

    # GET /api/customers/:customer_id/preferences/:id
    def show
      render json: @preference
    end

    # PUT /api/customers/:customer_id/preferences/:id
    def update
      preference = @customer.preferences.find_or_initialize_by(key: params[:id])
      
      # Check if we have a value parameter
      if preference_params[:value].nil?
        render json: { errors: ['Value parameter is required'] }, status: :unprocessable_entity
        return
      end
      
      if preference.update(value: preference_params[:value])
        render json: preference
      else
        render json: { errors: preference.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/customers/:customer_id/preferences/:id
    def destroy
      @preference.destroy
      head :no_content
    end

    private

    def set_customer
      @customer = Customer.find(params[:customer_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Customer not found' }, status: :not_found
    end
    
    def set_preference
      @preference = @customer.preferences.find_by!(key: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Preference not found' }, status: :not_found
    end

    def authorize_owner_or_admin
      unless current_user && (current_user.id == @customer.id.to_i || current_user.admin?)
        render json: { error: 'Unauthorized' }, status: :forbidden
      end
    end
    
    def preference_params
      params.permit(:value)
    end
  end
end