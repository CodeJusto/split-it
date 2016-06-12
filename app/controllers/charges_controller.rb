class ChargesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def new
  end

  def create
    # Amount in cents
    @amount = params[:amount]
    @cart_id = params[:cart]
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
    @payment.save

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path

  end

  def refund
    puts params.inspect
    refund = Stripe::Refund.create(
      charge: params[:stripe_charge_id]
    )
    puts refund.inspect
    matching_payment = Payment.where(stripe_charge_id: refund.charge)
    puts matching_payment.inspect
    # payment = Payment.new(
    #   user_id: matching_payment.user_id,
    #   cart_id: matching_payment.cart_id,
    #   stripe_customer_id: charge.customer,
    #   stripe_charge_id: refund.charge,
    #   amount: refund.amount,
    #   status: "refunded"
    # ) 
  end

end