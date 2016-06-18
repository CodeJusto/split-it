class UsersController < ApplicationController

  def update
    # @cart = Cart.find(session[:cart_id])
    @user = User.find(params[:id])
    # @user.password = SecureRandom.uuid
    @user.update_attributes(user_params)
    if @user.save
      # @cart = Cart.find(session[:cart_id])
      render :json => {
        user: @user.as_json(include: :carts)
      }
    else

    end
  end

end