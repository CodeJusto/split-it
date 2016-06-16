require 'SecureRandom'

class Api::CartsController < Api::BaseController

  include CartsHelper

  skip_before_action :require_login, only: [:invite]

  def index
    @carts = current_user.carts
    render :json => {
      carts: @carts
    }
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.status_id = 1
    @cart.key = SecureRandom.uuid
    if @cart.save
      update_user_address(params)
      current_user.cart_roles.create(user_id: current_user.id, cart_id: @cart.id, role_id: 1)
      current_user.save
      params[:cart_id] = @cart.id
      # render Json
      render :json => {
        # :payment => format_price(@payment.amount),
        :cart => @cart
        }
    else
      render :json => {errors: "Cart creation failed, ya toucan!"}.to_json, status: 400
      # render error message iN JSON
    end
  end

  protected


  def cart_params
    params.require(:cart).permit(
      :name, :expiry, :street_address, :street_address2, :country, :city, :province, :zip_code
    )
  end

end