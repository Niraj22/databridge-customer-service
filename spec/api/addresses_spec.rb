# spec/requests/api/addresses_spec.rb
require 'swagger_helper'

RSpec.describe 'Addresses API', type: :request do
  path '/api/customers/{customer_id}/addresses' do
    parameter name: :customer_id, in: :path, type: :integer

    get 'Retrieves all addresses for a customer' do
      tags 'Addresses'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'addresses found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              customer_id: { type: :integer },
              address_type: { type: :string },
              street: { type: :string },
              city: { type: :string },
              state: { type: :string, nullable: true },
              postal_code: { type: :string },
              country: { type: :string },
              is_default: { type: :boolean },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        
        let(:customer_id) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User').id }
        run_test!
      end

      response '404', 'customer not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:customer_id) { 'invalid' }
        run_test!
      end
    end

    post 'Creates an address for a customer' do
      tags 'Addresses'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :address, in: :body, schema: {
        type: :object,
        properties: {
          address_type: { type: :string, enum: ['shipping', 'billing'], example: 'shipping' },
          street: { type: :string, example: '123 Main St' },
          city: { type: :string, example: 'New York' },
          state: { type: :string, example: 'NY' },
          postal_code: { type: :string, example: '10001' },
          country: { type: :string, example: 'US' },
          is_default: { type: :boolean, example: true }
        },
        required: ['address_type', 'street', 'city', 'postal_code', 'country']
      }

      response '201', 'address created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            customer_id: { type: :integer },
            address_type: { type: :string },
            street: { type: :string },
            city: { type: :string },
            state: { type: :string, nullable: true },
            postal_code: { type: :string },
            country: { type: :string },
            is_default: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:customer_id) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User').id }
        let(:address) { { address_type: 'shipping', street: '123 Main St', city: 'New York', postal_code: '10001', country: 'US', is_default: true } }
        run_test!
      end
    end
  end

  path '/api/customers/{customer_id}/addresses/{id}' do
    parameter name: :customer_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves an address' do
      tags 'Addresses'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'address found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            customer_id: { type: :integer },
            address_type: { type: :string },
            street: { type: :string },
            city: { type: :string },
            state: { type: :string, nullable: true },
            postal_code: { type: :string },
            country: { type: :string },
            is_default: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:customer) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User') }
        let(:customer_id) { customer.id }
        let(:address) { customer.addresses.create(address_type: 'shipping', street: '123 Main St', city: 'New York', postal_code: '10001', country: 'US') }
        let(:id) { address.id }
        run_test!
      end
    end

    put 'Updates an address' do
      tags 'Addresses'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :address, in: :body, schema: {
        type: :object,
        properties: {
          street: { type: :string, example: '456 New St' },
          city: { type: :string, example: 'Boston' },
          state: { type: :string, example: 'MA' },
          postal_code: { type: :string, example: '02110' },
          country: { type: :string, example: 'US' },
          is_default: { type: :boolean, example: true }
        }
      }

      response '200', 'address updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            customer_id: { type: :integer },
            address_type: { type: :string },
            street: { type: :string },
            city: { type: :string },
            state: { type: :string, nullable: true },
            postal_code: { type: :string },
            country: { type: :string },
            is_default: { type: :boolean },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:customer) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User') }
        let(:customer_id) { customer.id }
        let(:address_record) { customer.addresses.create(address_type: 'shipping', street: '123 Main St', city: 'New York', postal_code: '10001', country: 'US') }
        let(:id) { address_record.id }
        let(:address) { { street: '456 New St', city: 'Boston' } }
        run_test!
      end
    end

    delete 'Deletes an address' do
      tags 'Addresses'
      security [bearer_auth: []]

      response '204', 'address deleted' do
        let(:customer) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User') }
        let(:customer_id) { customer.id }
        let(:address) { customer.addresses.create(address_type: 'shipping', street: '123 Main St', city: 'New York', postal_code: '10001', country: 'US') }
        let(:id) { address.id }
        run_test!
      end
    end
  end
end