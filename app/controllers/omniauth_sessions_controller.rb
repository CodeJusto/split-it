class OmniauthSessionsController < ApplicationController
  def create
    session[:errors] = nil
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id

      if session[:key]
        key = session[:key]
        session[:key] = nil
        CartRole.create(user_id: user.id, cart_id: key, role_id: 2, email_notifications: true, text_notifications: true)
        # Will only redirect users to the invite page IF that is how 
        # they reached the site in the first place

        redirect_to "http://localhost:3000/dashboard/?token=#{user.id}"
      else
        redirect_to "http://localhost:3000/dashboard/?token=#{user.id}"
      end
  end

end
