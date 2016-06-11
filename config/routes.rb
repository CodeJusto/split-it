Rails.application.routes.draw do

  resources :sessions, only:[:create, :destroy]

  resources :charges

  resources :users

  resources :carts

  namespace :final_boss do
    resources :users
    resources :carts
    resources :charges
  end

  resources :sessions, only:[:create, :destroy]

  root to: 'users#index'
end
