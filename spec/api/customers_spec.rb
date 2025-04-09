# spec/requests/api/customers_spec.rb
require 'swagger_helper'

RSpec.describe 'Customers API', type: :request do
  path '/api/customers' do
    get 'Retrieves all customers' do
      tags 'Customers'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :page, in: :query, type: :integer, required: false, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, required: false, description: 'Items per page'
      parameter name: :status, in: :query, type: :string, required: false, description: 'Filter by status'
      parameter name: :role, in: :query, type: :string, required: false, description: 'Filter by role'
      parameter name: :sort_by, in: :query, type: :string, required: false, description: 'Field to sort by'
      parameter name: :sort_direction, in: :query, type: :string, required: false, enum: ['asc', 'desc'], description: 'Sort direction'

      response '200', 'customers found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string },
              name: { type: :string },
              role: { type: :string },
              status: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' },
              last_login_at: { type: :string, format: 'date-time', nullable: true }
            }
          }
        
        run_test!
      end

      response '403', 'forbidden' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        run_test!
      end
    end

    post 'Creates a customer' do
      tags 'Customers'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' },
          name: { type: :string, example: 'John Doe' },
          role: { type: :string, enum: ['customer', 'admin'], example: 'customer' }
        },
        required: ['email', 'password', 'name']
      }

      response '201', 'customer created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            name: { type: :string },
            role: { type: :string },
            status: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            last_login_at: { type: :string, format: 'date-time', nullable: true }
          }
        
        let(:customer) { { email: 'new@example.com', password: 'password123', name: 'New User' } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string }
            }
          }
        
        let(:customer) { { email: 'invalid-email' } }
        run_test!
      end
    end
  end

  path '/api/customers/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a customer' do
      tags 'Customers'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'customer found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            name: { type: :string },
            role: { type: :string },
            status: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            last_login_at: { type: :string, format: 'date-time', nullable: true }
          }
        
        let(:id) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User').id }
        run_test!
      end

      response '404', 'customer not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a customer' do
      tags 'Customers'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'updated@example.com' },
          name: { type: :string, example: 'Updated Name' },
          status: { type: :string, enum: ['active', 'inactive', 'suspended'], example: 'active' }
        }
      }

      response '200', 'customer updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string },
            name: { type: :string },
            role: { type: :string },
            status: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' },
            last_login_at: { type: :string, format: 'date-time', nullable: true }
          }
        
        let(:id) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User').id }
        let(:customer) { { name: 'Updated Name' } }
        run_test!
      end

      response '404', 'customer not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        let(:customer) { { name: 'Updated Name' } }
        run_test!
      end
    end

    delete 'Deactivates a customer' do
      tags 'Customers'
      security [bearer_auth: []]

      response '204', 'customer deactivated' do
        let(:id) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User').id }
        run_test!
      end

      response '404', 'customer not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end