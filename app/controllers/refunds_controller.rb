class RefundsController < ApplicationController
  
  def create
    stripe_refund = Stripe::Refund.create(
      charge: params[:stripe_charge_id]
    )

    matching_payment = Payment.find_by(stripe_charge_id: params[:stripe_charge_id])
    refund = Refund.new(
      user_id: matching_payment.user_id,
      cart_id: matching_payment.cart_id,
      payment_id: matching_payment.id,
      stripe_customer_id: matching_payment.stripe_customer_id,
      stripe_charge_id: stripe_refund.charge,
      amount: stripe_refund.amount,
    )
    payment.save
  end

end
