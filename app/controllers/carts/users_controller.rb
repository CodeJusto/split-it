class Carts::UsersController < ApplicationController

 def remove
  @user = User.find(params[:id])
  @cart = Cart.find(params[:cart_id])
  deleted_user = CartRole.find_by(user_id: @user.id, cart_id: @cart.id)
  if deleted_user.destroy
    Notifications.delete_contributor(@user, @cart).deliver_now
    # Do we need to create a notification row for this?
  end
  redirect_to cart_path(@cart)
  end

  def invite
    @inviter = current_user
    @cart = Cart.find(params[:cart_id])
    @emails = params[:emails]
    @emails.each do |key, email|
      # binding.pry
      Notifications.invite_contributor(@inviter, @cart, email).deliver_now
      # Do we need to create a notification row for this?
    end
    redirect_to root_path
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end