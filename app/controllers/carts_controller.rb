require 'securerandom'

class CartsController < ApplicationController
  
  include CartsHelper

  skip_before_action :require_login, only: [:invite]

  # def index
  # end

  # def new
  #   @cart = Cart.new
  # end

  def email_preferences 
    @cart = Cart.find(session[:cart_id])
    session[:cart_id] = nil
    @cart_role = CartRole.find_by(user_id: current_user.id, cart_id: params[:cart_id])
    @cart_role.email_notifications = !!(params[:email_notifications])
    @cart_role.save
    redirect_to cart_path(@cart)
  end

  def text_preferences 
    @cart = Cart.find(session[:cart_id])
    session[:cart_id] = nil
    @cart_role = CartRole.find_by(user_id: current_user.id, cart_id: params[:cart_id])
    @cart_role.text_notifications = !!(params[:text_notifications]) 
    @cart_role.save
    redirect_to cart_path(@cart)
  end  

  def cookie
    @user = User.new
  end

  def invite
    # @user = User.new
    @cart = Cart.find_by(key: params[:key])
    session[:key] = @cart.id
    # @cart_array = @cart.cart_roles.map do |c|
    #   c.user_id
    # end
    @email = params[:email]
    redirect_to root_path
  end


  protected 

  def cart_params
    params.require(:cart).permit(
      :name, :expiry, :street_address, :street_address2, :country, :city, :province, :zip_code
    )
  end

  def update_cart_params
    params.require(:cart).permit(
      :custom_minimum_payment
    )
  end


  private

  def require_login
    unless current_user
      session[:key] = params[:key]
      #Display error message
      redirect_to root_path
    end
  end
end
