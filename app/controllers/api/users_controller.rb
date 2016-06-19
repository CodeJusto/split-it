class UsersController < ApplicationController

  def update
    # @cart = Cart.find(session[:cart_id])
    @user = CartRole.find_by(user_id: params[:user_id], cart_id: params[:cart_id])
    # @user.password = SecureRandom.uuid
    @user.update_attributes()
    if @user.save
      # @cart = Cart.find(session[:cart_id])
      render :json => {
        user: @user.as_json(include: :carts)
      }
    else

    end
  end

end