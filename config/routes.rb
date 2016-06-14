Rails.application.routes.draw do

  resources :sessions, only:[:create, :destroy]

  resources :charges

  resources :users

  delete '/remove/:id', to: 'users#remove', as: 'remove_user'

  resources :carts do 
    patch '/preferences', to: 'carts#preferences', as: 'preferences'
  end


  namespace :carts do
    scope '/:cart_id' do
      # resource :products, only:[:new, :create]
      resources :products
    end
  end

  # resources :products

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
