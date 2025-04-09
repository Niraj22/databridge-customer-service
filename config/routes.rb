Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    # Auth endpoints
    post 'auth/login', to: 'auth#login'
    post 'auth/register', to: 'auth#register'
    
    # Customer endpoints
    resources :customers do
      resources :addresses
      resources :preferences, only: [:index, :show, :update, :destroy]
    end
  end
  
  # Health check endpoint
  root to: proc { [200, {}, ['DataBridge Customer Service']] }
end
