Rails.application.routes.draw do

  resources :sessions, only:[:create, :destroy]

  resources :charges

  resources :users

  resources :users do
    get '/login', to: 'users#login_test' # delete this before deployment
  end
# test index for cookie testing
get '/cookie', to: 'carts#cookie', as: 'cookie'

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

  # api
  namespace :api do
    resources :charges, only: [:create]
    resources :carts, only: [:index, :create, :invite, :show, :destroy] do 
      post '/users/invite', to: 'carts/users#invite'
    end
    resources :users, only: [:create]
  end

  post '/api/charges', to: 'charges#create'
  post '/api/carts/:id/products', to: 'api/carts/products#create'
  get 'api/carts/token/:token', to: 'api/carts#index'
  get '/api/carts/:id/:token', to:'api/carts#show'

  resources :sessions, only:[:create, :destroy]

  get 'auth/:provider/callback', to: 'omniauth_sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  # admin
  namespace :admin do
    resources :users
    resources :carts, only:[:index]
    resources :charges
  end

  root to: 'users#index'

end
