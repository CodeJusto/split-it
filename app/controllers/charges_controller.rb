class ChargesController < ApplicationController
  include CartsHelper

  skip_before_filter :verify_authenticity_token

  def new
  end

  def create
    
    @amount = convert_to_cents(params[:amount])
    @cart_id = params[:cart]
    @cart = Cart.where(id: @cart_id)
    token = params[:stripeToken]

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'    
    )
    
    @payment = Payment.new(
      user_id: current_user.id,
      cart_id: @cart_id,
      stripe_customer_id: charge.customer,
      stripe_charge_id: charge.id,
      amount: charge.amount
    ) 
    
    @payee = User.where(id: @payment.user_id)

    @payment.save
    if @payment.save
      @cart = Cart.find(@payment.cart_id)
      @updated_cart_total = calculate_total_payments(get_cart_payments(@cart.id))
      @goal = @cart.total
      @updated_pctg = cart_progress(@updated_cart_total, @goal)
      # @total = @cart.payments.sum(:amount)
      organizer = User.joins(:cart_roles).where('cart_roles.cart_id' => @cart_id, 'cart_roles.role_id' => 1, 'cart_roles.notifications' => true )  
      Notifications.update_contributor(organizer, @payee, @payment).deliver_now unless organizer.empty?
      Notification.create(cart_id: @cart_id, notification_template_id: 2)

      if request.xhr?
      render :json => {
        :payment => format_price(@payment.amount),
        :payee => @payee,
        :updated_cart_total => format_price(@updated_cart_total),
        :updated_pctg => @updated_pctg,
        :stripe_charge_id => charge.id
        }                   
      else
        redirect(back)
      end
    else
      redirect(back)
    end


    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path

  end

end