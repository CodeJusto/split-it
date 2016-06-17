require 'SecureRandom'
class UsersController < ApplicationController
  # def index
  #   @cart = Cart.new
  #   @user = User.new
  #   @carts = current_user.carts if current_user

  #   return @carts
  # end



  def destroy
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password, :number)
  end

end
