class OmniauthSessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    session[:facebook] = true
    redirect_to root_url
  end

end
