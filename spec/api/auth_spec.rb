# spec/requests/api/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/auth/register' do
    post 'Registers a new customer' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
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

      response '201', 'customer registered' do
        schema type: :object,
          properties: {
            token: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                role: { type: :string },
                status: { type: :string },
                created_at: { type: :string, format: 'date-time' }
              }
            }
          }
        
        let(:customer) { { email: 'user@example.com', password: 'password123', name: 'John Doe' } }
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
        
        let(:customer) { { email: 'invalid-email', password: 'pass' } }
        run_test!
      end
    end
  end

  path '/api/auth/login' do
    post 'Authenticates customer' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', 'customer authenticated' do
        schema type: :object,
          properties: {
            token: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                role: { type: :string },
                status: { type: :string },
                created_at: { type: :string, format: 'date-time' }
              }
            }
          }
        
        let(:credentials) { { email: 'user@example.com', password: 'password123' } }
        run_test!
      end

      response '401', 'invalid credentials' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        
        let(:credentials) { { email: 'user@example.com', password: 'wrong_password' } }
        run_test!
      end
    end
  end
end