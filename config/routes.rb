Rails.application.routes.draw do

  resources :sessions, only:[:create, :destroy]

  resources :charges

  resources :users

  resources :carts

  get '/invite/:key', to: 'carts#invite', as: 'carts_invite'

  post 'refund', to: 'charges#refund', as: 'refund'

  namespace :final_boss do
    resources :users
    resources :carts
    resources :charges
  end

  resources :sessions, only:[:create, :destroy]

  get 'auth/:provider/callback', to: 'omniauth_sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root to: 'users#index'

end
