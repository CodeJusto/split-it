class Api::Carts::UsersController < ApplicationController
 skip_before_action :verify_authenticity_token

  def current_user
    @current_user ||= User.find(params[:id]) unless params[:id].nil?
  end

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
    #THE RIGHT ONE
      @inviter = current_user
      @cart = Cart.find(params[:cart_id])
      @email = params[:email]
      # @emails.each do |key, email|
        Notifications.invite_contributor(@inviter, @cart, @email).deliver_now
        # Do we need to create a notification row for this?
      # end 
      render :json => { message: "Hey buddo, your invitation was sent successfully."}, status: 200
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end