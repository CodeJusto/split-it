require 'SecureRandom'

class CartsController < ApplicationController
  
  include CartsHelper

  skip_before_action :require_login, only: [:invite]

  def index
  end

  def create
    @cart = Cart.new(cart_params)
    ## stores the minimum payment in cents so users can input a regular
    ## dollar amount
    @cart.minimum_payment = convert_to_cents(cart_params[:minimum_payment])
    @cart.status_id = 1
    @cart.key = SecureRandom.uuid
    if @cart.save
      current_user.save
      current_user.cart_roles.create(user_id: current_user.id, cart_id: @cart.id, role_id: 1)
      params[:cart_id] = @cart.id
      redirect_to cart_path(@cart)
    end
  end

  def show
    @contributors = []
    @cart = Cart.find(params[:id])
    session[:cart_id] = @cart.id
    # @users = @cart.users

    @cart_payments = get_cart_payments(@cart.id)
    ## cart_payments returns an array of all payments made - including
    ## username, id, amount, date
    @total_payments = calculate_total_payments(@cart_payments)

    @display_minimum_payment = ((@cart.minimum_payment / 100).to_f)

    # Sorts through those users to find which users belong to your current cart
    @contributors = @cart.users
    # CartRole.where(cart_id: @cart.id).uniq
    # Query all the products in the cart
    @products = @cart.products
    
    # @goal = 20000
    # the goal is hard-coded now
    # @users = User.joins(cart_roles: :carts)
    @cart_payments = get_cart_payments(@cart.id)
    @cart_refunds = Refund.where(cart_id: @cart.id).sum(:amount)
    @total_paid = @cart_payments.sum(:amount)
    
    # @progress = cart_progress(@total_paid, @goal)
    @progress = @total_paid # Error here, not getting the total_paid 
    # @progress = @cart.total == 0 ? 0 : @total_paid / @cart.total * 100.00

    @cart.cart_roles.each do |c|
      if current_user.id == c.user_id
        render 'show' and return
      end
    end
    
    # Notify them they do not have access
    redirect_to root_path
  end

  def invite
    @user = User.new
    @cart = Cart.find_by(key: params[:key])
    @cart_array = @cart.cart_roles.map do |c|
      c.user_id
    end
    @email = params[:email]
  end

  def update

  end

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

  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy
    redirect_to root_path
  end

  protected 

  def cart_params
    params.require(:cart).permit(
      :name, :expiry, :minimum_payment
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
