require 'SecureRandom'

class CartsController < ApplicationController
  
  include CartsHelper

  skip_before_action :require_login, only: [:invite]

  def index
  end

  def new
    @cart = Cart.new
  end

  def create
    @cart = Cart.new(cart_params)
<<<<<<< HEAD
    ## stores the minimum payment in cents so users can input a regular
    ## dollar amount
=======
>>>>>>> 6922f593b81fa9ffdac938c74a433e1cd3dfe870
    @cart.status_id = 1
    @cart.key = SecureRandom.uuid
    if @cart.save!
      
      update_user_address(params)
      current_user.cart_roles.create(user_id: current_user.id, cart_id: @cart.id, role_id: 1)
      current_user.save
      params[:cart_id] = @cart.id
      redirect_to cart_path(@cart)
    end
  end

  def show
    @contributors = []
    @cart = Cart.find(params[:id])

    # if cart has product, update status to 'Active'
    # @cart.update(status_id: 2) if @cart.products.size > 0
    @cart.check_status

    session[:cart_id] = @cart.id

    @cart_payments = get_cart_payments(@cart.id)
    ## cart_payments returns an array of all payments made - including
    ## username, id, amount, date

    @cart_refunds = Refund.where(cart_id: @cart.id).sum(:amount)

    # Sorts through those users to find which users belong to your current cart
    @contributors = CartRole.where(cart_id: @cart.id).uniq
    # Query all the products in the cart from Amazon
    @products = @cart.products
    @goal = @cart.total

    @contributors = @cart.users
    # Query all the products in the cart
    @products = @cart.products
    @remaining_balance = (@goal - @total_payments)

    if @cart.custom_minimum_payment.nil?
      @minimum_payment = (@remaining_balance / @contributors.length)
    else
      @minimum_payment = @cart.custom_minimum_payment
    end

    @cart_payments = get_cart_payments(@cart.id)
    @cart_refunds = Refund.where(cart_id: @cart.id).sum(:amount)
    @progress = @cart.progress
    @cart_payments = @cart.total_payment

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
    @cart = Cart.find(session[:cart_id])
    @cart.update(custom_minimum_payment: convert_to_cents(update_cart_params[:custom_minimum_payment]))
    @cart.save
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
    @cart = Cart.find(session[:cart_id])
    # @cart.destroy
    # instead of destroying the cart, we 'archive' it
    @cart.update(status_id: 6)

    # Refactor this!
    contributor_email = find_role(2, "email")
    unless contributor_email.empty?
      contributor_email.each do |c| 
        Notifications.cart_deleted(c, @cart).deliver_now unless contributor_email.empty?
      end
    Notification.create(cart_id: @cart_id, notification_template_id: 2)
    end

    contributor_text = find_role(2, "text")
    unless contributor_text.empty?
      contributor_text.each do |text| 
        $twilio.account.sms.messages.create(
          :from => ENV['COMPANY_PHONE'],
          :to => "+1#{text.number}",
          :body => "The organizer for #{@cart.name} has deleted your cart. All payments will be refunded."
        )
      end
    end
    redirect_to root_path
  end

  protected 

  def cart_params
    params.require(:cart).permit(
<<<<<<< HEAD
      :name, :expiry, :street_address, :street_address2, :country, :city, :province, :zip_code
=======
      :name, :expiry
    )
  end

  def update_cart_params
    params.require(:cart).permit(
      :custom_minimum_payment
>>>>>>> 6922f593b81fa9ffdac938c74a433e1cd3dfe870
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
