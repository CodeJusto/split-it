require 'SecureRandom'

class CartsController < ApplicationController
  
  include CartsHelper

  before_action :require_login

  def index
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.status_id = 1
    @cart.key = SecureRandom.uuid
    if @cart.save
      current_user.save
      current_user.cart_roles.create(user_id: current_user.id, cart_id: @cart.id, role_id: 1)
      params[:cart_id] = @cart.id
      redirect_to cart_path(@cart)
    else

    end
  end

  def show
    @current_users = []
    @cart = Cart.find(params[:id])
    @goal = 20000
    # the goal is hard-coded now
    # @users = User.joins(cart_roles: :carts)
    @users = User.joins("INNER JOIN cart_roles ON cart_roles.user_id = users.id INNER JOIN carts ON carts.id = cart_roles.cart_id")
    @current_users = @users.select { |u| u if @cart.cart_roles.map {|r| r.user_id == u.id}.include? true }.map {|i| i}
    # @current_users.flatten
    @cart_contributions = Payment.where(cart_id: @cart.id).where(status: "paid")
    @cart_payments = @cart_contributions.sum(:amount)
    @cart_refunds = Payment.where(cart_id: @cart.id).where(status: "refunded").sum(:amount)
    @total_paid = (@cart_payments - @cart_refunds)
    
    @progress = cart_progress(@total_paid, @goal)

    @cart.cart_roles.each do |c|
      if current_user.id == c.user_id
        # binding.pry
        render 'show' and return
      end
    end

    # Notify them they do not have access
    redirect_to root_path
  end

 #  get '/invite/:user_id/:cart_name', to: 'carts#invite', as 'carts_invite'
  def invite
    @cart = Cart.find_by(key: params[:key])
    @cart_array = @cart.cart_roles.map do |c|
      c.user_id
    end
    # binding.pry
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

  private

  def require_login
    unless current_user
      redirect_to root_path
    end
  end

end
