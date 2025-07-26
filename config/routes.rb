Rails.application.routes.draw do
  get "sms/receive"
  post '/sms/receive', to: 'sms#receive'

  root "recipes#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session
  resources :passwords, param: :token
  resources :recipes

  # ---------------------------------------------------------------------------
  # Admin namespace – only accessible to users with `admin: true`.
  # ---------------------------------------------------------------------------
  namespace :admin do
    resources :failed_imports, only: [:index] do
      # Allows an admin to trigger a manual re-import attempt.
      post :retry, on: :member
    end
  end
end
