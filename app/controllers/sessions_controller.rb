class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if session[:key]
        key = session[:key]
        session[:key] = nil
        CartRole.create(user_id: user.id, cart_id: key, role_id: 2, email_notifications: true, text_notifications: true)

        # Will only redirect users to the invite page IF that is how 
        # they reached the site in the first place
      end
      redirect_to "http://www.localhost:3000/dashboard?token=#{user.id}"

    else
      flash.now[:alert] = "Log in failed..."
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    session[:key] = nil
    redirect_to root_url
  end
end
