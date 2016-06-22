require 'SecureRandom'
class UsersController < ApplicationController
  def index
    @user = User.new
    render :index
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      Notifications.welcome_email(@user).deliver_now
      redirect_to "http://localhost:3000/dashboard?token=#{user.id}"
    else
      redirect_to root_path
    end
  end


  def destroy
  end

  def login_test
    cookies[:user_name] = User.find(params[:user_id]).name
    cookies[:user_id] = params[:user_id]
    session[:user_id] = params[:user_id]
    redirect_to "http://localhost:3000/dashboard?token=#{params[:user_id]}"
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password, :number)
  end

end
