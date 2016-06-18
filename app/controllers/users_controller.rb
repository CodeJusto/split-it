require 'SecureRandom'
class UsersController < ApplicationController
  # def index
  #   @cart = Cart.new
  #   @user = User.new
  #   @carts = current_user.carts if current_user

  #   return @carts
  # end

def create
    session[:errors] = nil
    @user = User.new(user_params)
    if @user.save 
      Notifications.welcome_email(@user).deliver_now
      session[:user_id] = @user.id
      cookies[:user_name] = @user.name
      if session[:key]
        key = session[:key]
        session[:key] = nil
        @cart = Cart.find_by(key: params[:key])
        # Will only redirect users to the invite page IF that is how 
        # they reached the site in the first place
         redirect_to root_path
      else
         redirect_to root_path 
      end
    else
         redirect_to root_path
    end
  end


  def destroy
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password, :number)
  end

end
