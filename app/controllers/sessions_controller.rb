class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "http://localhost:3000/dashboard?token=#{user.id}"
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
