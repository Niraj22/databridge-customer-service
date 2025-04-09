module Api
    class CustomersController < ApplicationController
      before_action :set_customer, only: [:show, :update, :destroy]
      before_action :authorize_admin, only: [:index]
      before_action :authorize_owner_or_admin, only: [:show, :update, :destroy]
  
      def index
        customers = Customer.all
        customers = apply_filters(customers)
        
        render json: paginate(customers).map { |c| customer_response(c) }
      end
  
      def show
        render json: customer_response(@customer)
      end
  
      def create
        customer = Customer.new(customer_params)
        
        if customer.save
          customer.publish_created_event
          render json: customer_response(customer), status: :created
        else
          render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      def update
        if @customer.update(customer_update_params)
          @customer.publish_updated_event
          render json: customer_response(@customer)
        else
          render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      def destroy
        @customer.update(status: 'inactive')
        head :no_content
      end
  
      private
  
      def set_customer
        @customer = Customer.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Customer not found' }, status: :not_found
      end
  
      def customer_params
        params.permit(:email, :password, :name, :role)
      end
  
      def customer_update_params
        # Don't allow role updates through this endpoint
        params.permit(:email, :name, :status)
      end
  
      def customer_response(customer)
        {
          id: customer.id,
          email: customer.email,
          name: customer.name,
          role: customer.role,
          status: customer.status,
          created_at: customer.created_at,
          updated_at: customer.updated_at,
          last_login_at: customer.last_login_at
        }
      end
  
      def authorize_admin
        unless current_user && current_user.admin?
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
  
      def authorize_owner_or_admin
        debugger
        unless current_user && (current_user.id.to_s == params[:id] || current_user.admin?)
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
  
      def apply_filters(customers)
        customers = customers.where(status: params[:status]) if params[:status].present?
        customers = customers.where(role: params[:role]) if params[:role].present?
        
        if params[:sort_by].present?
          direction = params[:sort_direction] == 'desc' ? :desc : :asc
          customers = customers.order(params[:sort_by] => direction)
        else
          customers = customers.order(created_at: :desc)
        end
        
        customers
      end
  
      def paginate(customers)
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 20).to_i
        
        customers.limit(per_page).offset((page - 1) * per_page)
      end
    end
  end