class RefundsController < ApplicationController
  include CartsHelper
  def create
    stripe_refund = Stripe::Refund.create(
      charge: params[:id]
    )

    @matching_payment = Payment.find_by(stripe_charge_id: params[:id])
    refund = Refund.new(
      user_id: @matching_payment.user_id,
      cart_id: @matching_payment.cart_id,
      payment_id: @matching_payment.id,
      stripe_customer_id: @matching_payment.stripe_customer_id,
      stripe_charge_id: params[:id],
      amount: stripe_refund.amount,
    )
    if refund.save
      @cart = Cart.find(refund.cart_id)
      @updated_cart_total = calculate_total_payments(get_cart_payments(@cart.id))
      @goal = @cart.total
      @updated_pctg = cart_progress(@updated_cart_total, @goal)
      if request.xhr?
        render :json => { 
          :refund => refund,
          :updated_cart_total => format_price(@updated_cart_total),
          :updated_pctg => @updated_pctg
        }
      else
      redirect_to cart_path(refund.cart_id)
      end
    else
      redirect_to cart_path(refund.cart_id)
    end
  end

  def refund_expired_carts
    @expired_carts = Cart.where(:expiry < Date.now)
    @expired_cart_payments = @expired_carts.payments.pluck(:stripe_charge_id)
    
    @expired_cart_payments.each do |charge|
      stripe_refund = Stripe::Refund.create(
      charge: charge
    )
      @matching_payment = Payment.find_by(stripe_charge_id: charge)
      refund = Refund.new(
      user_id: @matching_payment.user_id,
      cart_id: @matching_payment.cart_id,
      payment_id: @matching_payment.id,
      stripe_customer_id: @matching_payment.stripe_customer_id,
      stripe_charge_id: charge,
      amount: stripe_refund.amount
    )
      refund.save
    end
    @expired_carts.delete_all 
  end

end
