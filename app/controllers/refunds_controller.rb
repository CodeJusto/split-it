class RefundsController < ApplicationController
  
  def create
    stripe_refund = Stripe::Refund.create(
      charge: params[:id]
    )

    matching_payment = Payment.find_by(stripe_charge_id: params[:id])
    refund = Refund.new(
      user_id: matching_payment.user_id,
      cart_id: matching_payment.cart_id,
      payment_id: matching_payment.id,
      stripe_customer_id: matching_payment.stripe_customer_id,
      stripe_charge_id: params[:id],
      amount: stripe_refund.amount,
    )
    if refund.save
      if request.xhr?
        render :json => { :refund => refund }
      else
      redirect_to cart_path(refund.cart_id)
      end
    else
      redirect_to cart_path(refund.cart_id)
    end
  end

end
