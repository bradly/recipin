Rails.application.routes.draw do
  root "recipes#index"
  resources :recipes
  get 'profile', to: 'profile#show', as: :profile

  STATIC_PAGES.each do |page|
    get page, to: "pages##{page}", as: page
  end
end
