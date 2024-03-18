Rails.application.routes.draw do
  resources :plans
  resources :plan_items
  root "recipes#index"
  resources :recipes do
    resources :notes
  end

  get 'planner',      to: 'plans#index'
  get 'profile',      to: 'profile#show', as: :user_profile
  get 'profile/edit', to: 'profile#edit', as: :edit_user_profile

  if Rails.env.development?
    require 'mr_video'
    mount MrVideo::Engine => '/mr_video'
  end

  STATIC_PAGES.each do |page|
    get page, to: "pages##{page}", as: page
  end
end
