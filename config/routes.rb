Rails.application.routes.draw do
  root "recipes#index"
  resources :recipes
  resources :users

  STATIC_PAGES.each do |page|
    get page, to: "pages##{page}", as: page
  end
end
