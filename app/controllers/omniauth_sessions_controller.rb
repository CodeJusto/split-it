class OmniauthSessionsController < ApplicationController
  def create
    session[:errors] = nil
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    cookies[:user_name] = user.name
    cookies[:user_id] = user.id
    if session[:key]
        key = session[:key]
        session[:key] = nil
        # Will only redirect users to the invite page IF that is how 
        # they reached the site in the first place
        redirect_to carts_invite_path(key)
      else
        redirect_to root_path
      end
  end

end
