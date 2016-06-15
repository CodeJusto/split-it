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
      organizer_email = User.joins(:cart_roles).where('cart_roles.cart_id' => @cart_id, 'cart_roles.role_id' => 1, 'cart_roles.email_notifications' => true )  
      Notifications.update_contributor(organizer_email, @payee, @payment).deliver_now unless organizer_email.empty?
      Notification.create(cart_id: @cart_id, notification_template_id: 2)

      organizer_text = User.joins(:cart_roles).where('cart_roles.cart_id' => @cart_id, 'cart_roles.role_id' => 1, 'cart_roles.text_notifications' => true )  
      $twilio.account.sms.messages.create(
        :from => ENV['COMPANY_PHONE'],
        :to => "+17782286061",
        :body => "#{@payee[0].name} has contributed #{@payment.amount} for a cart!"
      )



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

end