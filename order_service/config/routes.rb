Rails.application.routes.draw do
  namespace :api do
    resources :orders, only: [:index, :create]
  end
end
