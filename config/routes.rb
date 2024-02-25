Rails.application.routes.draw do
  resources :notes
  root "recipes#index"
  resources :recipes

  get 'profile',      to: 'profile#show', as: :user_profile
  get 'profile/edit', to: 'profile#edit', as: :edit_user_profile

  STATIC_PAGES.each do |page|
    get page, to: "pages##{page}", as: page
  end
end
