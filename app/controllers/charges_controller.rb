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
      :currency    => 'usd',
      :capture     => false
    )


    puts "Customer ID: #{charge.customer}"
    puts "Charge ID: #{charge.id}"
    puts "Charge amount: #{charge.amount}"
    puts "Charge captured: #{charge.captured}"
    

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path

  end

end