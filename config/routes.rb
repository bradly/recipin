Rails.application.routes.draw do
  get "sms/receive"
  post '/sms/receive', to: 'sms#receive'

  root "recipes#index"
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    resources :failed_imports, only: [:index] do
      post :retry, on: :member
    end
  end

  resource :session
  resources :passwords, param: :token
  resources :recipes
end
