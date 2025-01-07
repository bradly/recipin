Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :recipes
  get "up" => "rails/health#show", as: :rails_health_check
  root "sessions#new"
end
