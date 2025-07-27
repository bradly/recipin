Rails.application.routes.draw do
  get "sms/receive"
  post '/sms/receive', to: 'sms#receive'

  root "recipes#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session
  resources :passwords, param: :token
  resources :recipes
end
