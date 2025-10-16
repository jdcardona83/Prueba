Rails.application.routes.draw do
  namespace :api do
    resources :customers, only: [:show]
  end
end
