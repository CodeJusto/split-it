class ChargesController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def new
  end

  def create
    # Amount in cents
    @amount = 500
    token = params[:stripeToken]

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    puts params.inspect

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'    
    )

    puts "Customer ID: #{charge.customer}"
    puts "Charge ID: #{charge.id}"
    puts "Charge amount: #{charge.amount}"
    puts "Charge captured: #{charge.captured}"
    
    @payment = Payment.new(
      user_id: 1,
      cart_id: 1,
      stripe_customer_id: charge.customer,
      stripe_charge_id: charge.id,
      amount: charge.amount,
      captured: charge.captured 
    ) 
    puts @payment.inspect
    @payment.save

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path

  end

  def refund
    puts "issuing a refund"
  end

end