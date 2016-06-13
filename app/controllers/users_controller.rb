class UsersController < ApplicationController
  def index
    @cart = Cart.new
    @user = User.new
    # @all = Cart.all # Remove later

    @carts = current_user.cart_roles.map { |role| Cart.find(role.cart_id) } if current_user
    # byebug

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
  end

  def destroy
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
