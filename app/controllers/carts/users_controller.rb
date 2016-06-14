class Carts::UsersController < ApplicationController

 def remove
    @user = User.find(params[:id])
    @cart = Cart.find(params[:cart_id])
    deleted_user = CartRole.find_by(user_id: @user.id, cart_id: @cart.id)
    if deleted_user.destroy
      Notifications.delete_contributor(@user, @cart).deliver_now
    end
    redirect_to cart_path(@cart)

  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end