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

    @payee = User.where(id: @payment.user_id)

    @payment.save
    if @payment.save
      organizer = User.joins(:cart_roles).where('cart_roles.cart_id' => @cart_id, 'cart_roles.role_id' => 1, 'cart_roles.notifications' => true )  
      Notifications.update_contributor(organizer, @payee, @payment).deliver_now unless organizer.empty?
      Notification.create(cart_id: @cart_id, notification_template_id: 2)

      if request.xhr?
      render :json => {
        :payment => @payment,
        :payee => @payee
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

  def refund
    refund = Stripe::Refund.create(
      charge: params[:stripe_charge_id]
    )
    matching_payment = Payment.find_by(stripe_charge_id: params[:stripe_charge_id])
    payment = Payment.new(
      user_id: matching_payment.user_id,
      cart_id: matching_payment.cart_id,
      stripe_customer_id: matching_payment.stripe_customer_id,
      stripe_charge_id: refund.charge,
      amount: refund.amount,
      status: "refunded"
    )
    payment.save
  end

end