# spec/requests/api/preferences_spec.rb
require 'swagger_helper'

RSpec.describe 'Preferences API', type: :request do
  path '/api/customers/{customer_id}/preferences' do
    parameter name: :customer_id, in: :path, type: :integer

    get 'Retrieves all preferences for a customer' do
      tags 'Preferences'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'preferences found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              customer_id: { type: :integer },
              key: { type: :string },
              value: { type: :string },
              created_at: { type: :string, format: 'date-time' },
              updated_at: { type: :string, format: 'date-time' }
            }
          }
        
        let(:customer_id) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User').id }
        run_test!
      end
    end
  end

  path '/api/customers/{customer_id}/preferences/{id}' do
    parameter name: :customer_id, in: :path, type: :integer
    parameter name: :id, in: :path, type: :string, description: 'Preference key'

    get 'Retrieves a preference' do
      tags 'Preferences'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'preference found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            customer_id: { type: :integer },
            key: { type: :string },
            value: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:customer) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User') }
        let(:customer_id) { customer.id }
        let(:preference) { customer.preferences.create(key: 'notification_emails', value: 'true') }
        let(:id) { preference.key }
        run_test!
      end
    end

    put 'Updates a preference' do
      tags 'Preferences'
      consumes 'application/json'
      produces 'application/json'
      security [bearer_auth: []]
      parameter name: :preference, in: :body, schema: {
        type: :object,
        properties: {
          value: { type: :string, example: 'false' }
        },
        required: ['value']
      }

      response '200', 'preference updated' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            customer_id: { type: :integer },
            key: { type: :string },
            value: { type: :string },
            created_at: { type: :string, format: 'date-time' },
            updated_at: { type: :string, format: 'date-time' }
          }
        
        let(:customer) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User') }
        let(:customer_id) { customer.id }
        let(:id) { 'notification_emails' }
        let(:preference) { { value: 'false' } }
        run_test!
      end
    end

    delete 'Deletes a preference' do
      tags 'Preferences'
      security [bearer_auth: []]

      response '204', 'preference deleted' do
        let(:customer) { Customer.create(email: 'test@example.com', password: 'password', name: 'Test User') }
        let(:customer_id) { customer.id }
        let(:preference) { customer.preferences.create(key: 'notification_emails', value: 'true') }
        let(:id) { preference.key }
        run_test!
      end
    end
  end
end