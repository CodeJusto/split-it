require 'SecureRandom'

class CartsController < ApplicationController
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
    end
  end

  def show
    @contributors = []
    @cart = Cart.find(params[:id])
    # Connect users, cart_roles, and carts
    @users = User.joins("INNER JOIN cart_roles ON cart_roles.user_id = users.id INNER JOIN carts ON carts.id = cart_roles.cart_id")
    # Sorts through those users to find which users belong to your current cart
    @contributors = CartRole.where(cart_id: @cart.id).uniq

    @cart.cart_roles.each do |c|
      if current_user.id == c.user_id
        @amazon = get_amazon_products(@cart.products)
        # byebug
        @products = @cart.products
        @cart_total = cart_total(@cart.products)
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

    response.to_h["ItemLookupResponse"]["Items"]["Item"]
  end

  def cart_total(products)
    product_ids = products.inject([]) { |arr, product| arr.push(product.external_id)  } 

    response = $amazon_request.item_lookup(
      query: {
        'ItemId' => product_ids.join(','),
        'ResponseGroup' => 'OfferSummary'
      }
    )

    items = response.to_h["ItemLookupResponse"]["Items"]["Item"]

    total = items.inject(0) { |sum, item| sum + item["OfferSummary"]["LowestNewPrice"]["Amount"].to_i * @cart.products.find_by(external_id: item["ASIN"]).quantity } / 100.00
  end
end
