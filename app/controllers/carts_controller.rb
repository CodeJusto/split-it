require 'SecureRandom'

class CartsController < ApplicationController
  
  include CartsHelper

  before_action :require_login

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
    # Connect users, cart_roles, and carts
    @users = User.joins("INNER JOIN cart_roles ON cart_roles.user_id = users.id INNER JOIN carts ON carts.id = cart_roles.cart_id")
    @current_users = @users.select { |u| u if @cart.cart_roles.map {|r| r.user_id == u.id}.include? true }.map {|i| i}
<<<<<<< HEAD
    # @current_users.flatten

    @cart_payments = get_cart_payments(@cart.id)
=======
    @display_minimum_payment = ((@cart.minimum_payment / 100).to_f)
    @cart_payments = Payment.where(cart_id: @cart.id)
>>>>>>> master
    # Sorts through those users to find which users belong to your current cart
    @contributors = CartRole.where(cart_id: @cart.id).uniq

    # Query all the products in the cart from Amazon
    @amazon = get_amazon_products(@cart.products)
    @products = @cart.products
    
    @goal = 20000
    # the goal is hard-coded now
    # @users = User.joins(cart_roles: :carts)
    @users = User.joins("INNER JOIN cart_roles ON cart_roles.user_id = users.id INNER JOIN carts ON carts.id = cart_roles.cart_id")
    @current_users = @users.select { |u| u if @cart.cart_roles.map {|r| r.user_id == u.id}.include? true }.map {|i| i}
    # @current_users.flatten
    @cart_payments = get_cart_payments(@cart.id)
    @cart_refunds = Refund.where(cart_id: @cart.id).sum(:amount)
    # @total_paid = (@cart_payments - @cart_refunds)
    
    # @progress = cart_progress(@total_paid, @goal)

    @cart.cart_roles.each do |c|
      if current_user.id == c.user_id
        render 'show' and return
      end
    end
    
    # Notify them they do not have access
    redirect_to root_path
  end

  def invite
    @cart = Cart.find_by(key: params[:key])
    @cart_array = @cart.cart_roles.map do |c|
    c.user_id
    end
  end

  def update

  end

  def preferences 
    @cart_role = CartRole.find_by(user_id: current_user.id, cart_id: params[:cart_id])
    @cart_role.notifications = !!(params[:notifications])
    @cart_role.save
    redirect_to root_path
  end

  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy
    redirect_to root_path
  end


  # def cart_total(id)
  #   products = Cart.find(id).products

  #   product_ids = products.inject([]) { |arr, product| arr.push(product.external_id)  } 

  #   response = $amazon_request.item_lookup(
  #     query: {
  #       'ItemId' => product_ids.join(','),
  #       'ResponseGroup' => 'OfferSummary'
  #     }
  #   )

  #   items = response.to_h["ItemLookupResponse"]["Items"]["Item"]
  #   return 0.00 if items.nil?
  #   total = items.inject(0) { |sum, item| sum + item["OfferSummary"]["LowestNewPrice"]["Amount"].to_i * @cart.products.find_by(external_id: item["ASIN"]).quantity } / 100.00
  # end

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
      redirect_to root_path
    end
  end

  def get_amazon_products(products)
    product_ids = products.inject([]) { |arr, product| arr.push(product.external_id)  } 
    response = $amazon_request.item_lookup(
      query: {
        'ItemId' => product_ids.join(','),
        'ResponseGroup' => 'ItemAttributes,Small,Images,OfferSummary'
      }
    )

    product_ids.size > 1 ? response.to_h["ItemLookupResponse"]["Items"]["Item"] : [response.to_h["ItemLookupResponse"]["Items"]["Item"]]
  end

end
