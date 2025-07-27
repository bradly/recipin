Rails.application.routes.draw do
  get "sms/receive"
  post '/sms/receive', to: 'sms#receive'

  root "recipes#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session
  resources :passwords, param: :token
  resources :recipes

  # Interest sign-up
  resources :account_requests, only: %i[new create]

  namespace :admin do
    resources :failed_imports, only: :index do
      post :retry, on: :member
    end

    resources :account_requests, only: :index do
      patch :dismiss,        on: :member
      post  :create_account, on: :member
    end
  end
end
