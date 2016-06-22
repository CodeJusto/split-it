require 'SecureRandom'

class Api::CartsController < Api::BaseController

  include CartsHelper

  skip_before_action :require_login, only: [:invite]

  def index
    @current_user = User.find(params[:token])
    @carts = @current_user.carts
    render :json => {
      user: @current_user,
      carts: @carts.as_json(methods: [:progress, :total, :total_payment, :organizer, :thumb_img], include: [:products, :status])
    }
  end

  def create
    @cart = Cart.new(
     name: params[:name], 
     expiry: params[:expiry], 
     street_address: params[:street_address], 
     street_address2: params[:street_address2], 
     country: params[:country], 
     city: params[:city], 
     province: params[:province], 
     zip_code: params[:zip_code]
    )
    @cart.status_id = 1
    @cart.key = SecureRandom.uuid
    if @cart.save
      update_user_address(params)
      current_user.cart_roles.create(user_id: current_user.id, cart_id: @cart.id, role_id: 1)
      current_user.save
      params[:cart_id] = @cart.id
      # render Json
      render :json => {
        # :payment => format_price(@payment.amount),
        :cart => @cart
        }
    else
      render :json => {errors: "There was a problem while creating your cart."}.to_json, status: 400
      # render error message iN JSON
    end
  end

  def invite
    # @user = User.new
    @cart = Cart.find_by(key: params[:key])
    # @cart_array = @cart.cart_roles.map do |c|
    #   c.user_id
    # end
    @email = params[:email]

    render :json => {
      cart: @cart.as_json(methods: [:progress, :total, :total_payment], include: [:products, :users])
    }
  end



  def show
    @contributors = []
    @cart = Cart.find(params[:id])

    # if cart has product, update status to 'Active'
    # @cart.update(status_id: 2) if @cart.products.size > 0
    @cart.check_status

    session[:cart_id] = @cart.id
    @cart_payments = get_cart_payments(@cart.id)
    @paying_contributors = Payment.where(cart_id: @cart.id).joins(:user)
    @cart_refunds = Refund.where(cart_id: @cart.id).sum(:amount)

    # Sorts through those users to find which users belong to your current cart
    @contributors = CartRole.where(cart_id: @cart.id).uniq
    # Query all the products in the cart from Amazon
    @products = @cart.products
    @goal = @cart.total

    @contributors = @cart.users.where('cart_roles.cart_id' => @cart.id, 'cart_roles.role_id' => 2)
    # Query all the products in the cart
    @products = @cart.products
    
    if (@goal - @cart.total_payment) < 0
      @remaining_balance = 0
    else
      @remaining_balance = (@goal - @cart.total_payment)
    end
    
    if @cart.custom_minimum_payment.nil?
      if @products.length == 0
        @minimum_payment = 0
      else 
        @minimum_payment = (@remaining_balance / (@contributors.length == 0 ? 1 : @contributors.length))

      end
    else
      @minimum_payment = @cart.custom_minimum_payment
    end

    @cart_payees = get_cart_payments(@cart.id)
    @cart_refunds = Refund.where(cart_id: @cart.id).sum(:amount)
    @progress = @cart.progress
    @cart_payments = @cart.total_payment
    @users_and_roles = @contributors.map do |contributor|
      contributor.roles.find_by('cart_roles.cart_id'=> @cart.id)
    end

    # @cart.cart_roles.each do |c|
    #   if current_user.id == c.user_id
    #     render 'show' and return
    #   end
    # end
    
    render :json => {
      cart: @cart.as_json(methods: [:progress, :total, :total_payment], include: [:products, :status, :users, :payments => { include: :user }]),
      organizer: @cart.organizer,
      contributors: @contributors,
      custom_minimum_payment: @minimum_payment,
      remaining_balance: @remaining_balance,
      current_user: User.find(params[:token])
    }
  end


   def destroy
    # SET THIS IN THE AJAX CALL PLEASE
    @cart = Cart.find(params[:cart_id])
    # instead of destroying the cart, we 'archive' it
    @cart.update(status_id: 6)

    contributor_email = find_role(2, "email")
    unless contributor_email.empty?
      contributor_email.each do |c| 
        Notifications.cart_deleted(c, @cart).deliver_now unless contributor_email.empty?
      end
    Notification.create(cart_id: @cart_id, notification_template_id: 2)
    end

    contributor_text = find_role(2, "text")
    unless contributor_text.empty?
      contributor_text.each do |text| 
        $twilio.account.sms.messages.create(
          :from => ENV['COMPANY_PHONE'],
          :to => "+1#{text.number}",
          :body => "The organizer for #{@cart.name} has deleted your cart. All payments will be refunded."
        )
      end
    end
   render :json => {
      cart: @cart.as_json(include: :status)
    }
  end

  def update
    @cart = Cart.find(session[:cart_id])
    @cart.update(custom_minimum_payment: convert_to_cents(update_cart_params[:custom_minimum_payment]))
    @cart.save

    render :json => {
      cart: @cart
    }
  end

  protected


  def cart_params
    params.require(:cart).permit(
      :name, :expiry, :street_address, :street_address2, :country, :city, :province, :zip_code
    )
  end

end