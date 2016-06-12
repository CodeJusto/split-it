class SessionsController < ApplicationController
  def create
     user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if session[:key]
        key = session[:key]
        session[:key] = nil
        # Will only redirect users to the invite page IF that is how 
        # they reached the site in the first place
        redirect_to carts_invite_path(key)
      else
        redirect_to root_path
      end
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
