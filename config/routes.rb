Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :recipes
  resources :ingredients
  resources :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "recipes#index"
end
