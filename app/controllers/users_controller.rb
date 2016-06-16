require 'SecureRandom'
class UsersController < ApplicationController
  def index
    @cart = Cart.new
    @user = User.new
    @carts = current_user.carts if current_user
    return @carts
  end

  def create
    session[:errors] = nil
    @user = User.new(user_params)
    if @user.save 
      Notifications.welcome_email(@user).deliver_now
      session[:user_id] = @user.id
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
      session[:errors] = @user.errors
      redirect_to root_path
    end
  end

  def update
    @cart = Cart.find(session[:cart_id])
    @user = User.find(params[:id])
    @user.password = SecureRandom.uuid
    @user.update_attributes(user_params)
    if @user.save
      @cart = Cart.find(session[:cart_id])
      session[:cart_id] = nil
      redirect_to cart_path(@cart) 
    end
  end

  def destroy
  end

  # for test only, will be deleted after
  def login_test
    session[:user_id] = User.first.id
    redirect_to carts_path
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password, :number)
  end

end
