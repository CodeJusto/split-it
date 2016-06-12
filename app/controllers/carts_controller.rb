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
    else

    end
  end

  def show
    @current_users = []
    @cart = Cart.find(params[:id])
    # @users = User.joins(cart_roles: :carts)
    @users = User.joins("INNER JOIN cart_roles ON cart_roles.user_id = users.id INNER JOIN carts ON carts.id = cart_roles.cart_id")
    @current_users = @users.select { |u| u if @cart.cart_roles.map {|r| r.user_id == u.id}.include? true }.map {|i| i}
    # @current_users.flatten

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
