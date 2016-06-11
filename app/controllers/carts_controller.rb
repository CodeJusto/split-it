require 'SecureRandom'

class CartsController < ApplicationController
  def index
  end

  def create
    @cart = Cart.new(cart_params)
    current_user.cart_roles.create(cart_id: @cart.id)

    @cart.status_id = 1
    if @cart.save
      current_user.save
      params[:cart_id] = @cart.id
      redirect_to cart_path(@cart)
    else

    end
  end

  def show

    @cart = Cart.find(params[:id])
    # if current_user == @cart.cart_roles

    # end    
  end

  def update
  end

  def destroy
  end

  protected 

  def cart_params
    params.require(:cart).permit(
      :name, :expiry, :minimum_payment
    )
  end
end
