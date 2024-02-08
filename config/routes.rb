Rails.application.routes.draw do
  root "recipes#index"
  resources :recipes

  EXTERNAL_PATHS = {
    about:         'https://github.com/bradly/recipin',
    blog:          'https://github.com/bradly/recipin',
    jobs:          'https://github.com/bradly/recipin',
    press:         'https://github.com/bradly/recipin',
    accessibility: 'https://github.com/bradly/recipin',
    partners:      'https://github.com/bradly/recipin',
  }
end
