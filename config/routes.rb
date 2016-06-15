Rails.application.routes.draw do

  resources :sessions, only:[:create, :destroy]

  resources :charges

  resources :users

  

  resources :carts do 
    patch '/email_preferences', to: 'carts#email_preferences', as: 'email_preferences'
    patch '/text_preferences', to: 'carts#text_preferences', as: 'text_preferences'
  end

  namespace :carts do
    scope '/:cart_id' do
      # resource :products, only:[:new, :create]
      resources :products
      delete '/remove/:id', to: 'users#remove', as: 'remove_user'
      post '/invite', to: 'users#invite', as: 'invite_user'
    end

  end

  # resources :products

  get '/invite/:key', to: 'carts#invite', as: 'carts_invite'

  post 'refunds', to: 'refunds#create', as: 'refunds'

  namespace :admin do
    resources :users
    resources :carts, only:[:index]
    resources :charges
  end

  resources :sessions, only:[:create, :destroy]

  get 'auth/:provider/callback', to: 'omniauth_sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root to: 'users#index'

end
