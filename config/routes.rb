Rails.application.routes.draw do
  get "sms/receive"
  post '/sms/receive', to: 'sms#receive'

  root "recipes#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session
  resources :passwords, param: :token

  resources :recipes
  resources :account_requests, only: [:new, :create]

  namespace :admin do
    resources :account_requests
    resources :failed_imports, only: :index do
      post :retry, on: :member
    end
  end
end
