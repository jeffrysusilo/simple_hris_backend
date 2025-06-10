Rails.application.routes.draw do
  # Auth routes
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'

  # Test protected route
  get "/secret", to: "protected_test#secret"

  # Employee CRUD
  resources :employees

  # Optional: Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Optional: Default root
  # root "posts#index"
end
