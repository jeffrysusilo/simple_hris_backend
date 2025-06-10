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

  resources :attendances, only: [:index] do
    collection do
      post :checkin
      post :checkout
    end
  end

  resources :leave_requests, only: [:index, :create] do
    member do
      patch :approve
      patch :reject
    end
  end

  get "/dashboard/summary", to: "dashboard#summary"

  resources :employees, only: [:index, :show, :create, :update, :destroy]

end
