class Api::ChargesController < Api::BaseController

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

    if @payment.save
      @cart = Cart.find(@payment.cart_id)
      @updated_cart_total = calculate_total_payments(get_cart_payments(@cart.id))
      @goal = @cart.total
      @updated_pctg = cart_progress(@updated_cart_total, @goal)
      # @total = @cart.payments.sum(:amount)

      organizer_email = find_role(1, 'email')
      contributor_email = find_role(2, 'email')
      Notifications.update_contributor(organizer_email, @payee, @payment).deliver_now unless organizer_email.empty?
      
      unless contributor_email.empty?
        contributor_email.each do |contributor|
          Notifications.send_invoice(contributor, @payment, @cart).deliver_now
        end
      end

      organizer_text = find_role(1, 'text')
      contributor_text = find_role(2, 'text')
      
      unless organizer_text.empty?
        organizer_text.each do |text| 
          $twilio.account.sms.messages.create(
            :from => ENV['COMPANY_PHONE'],
            :to => "+1#{text.number}",
            :body => "#{@payee[0].name} has contributed #{@payment.amount} for a cart!"
          )
        end
      end

      unless contributor_text.empty?
        contributor_text.each do |text| 
          $twilio.account.sms.messages.create(
            :from => ENV['COMPANY_PHONE'],
            :to => "+1#{text.number}",
            :body => "You have has contributed #{@payment.amount} for a cart!"
          )
        end
      end

      Notification.create(cart_id: @cart_id, notification_template_id: 2)

      #... json here
      render :json => {
        :payment => format_price(@payment.amount),
        :payee => @payee,
        :updated_cart_total => format_price(@updated_cart_total),
        :updated_pctg => @updated_pctg,
        :stripe_charge_id => charge.id
        }
    else
      render {error: "Payment failed."}.to_json, status: 400  # http response status is 400
    end


    rescue Stripe::CardError => e
      render {error: e.message}.to_json
  end
end