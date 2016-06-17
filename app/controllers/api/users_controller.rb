class UsersController < ApplicationController

  def create
    session[:errors] = nil
    @user = User.new(user_params)
    if @user.save 
      Notifications.welcome_email(@user).deliver_now
      session[:user_id] = @user.id
      if session[:key]
        key = session[:key]
        session[:key] = nil
        @cart = Cart.find_by(key: params[:key])
        # Will only redirect users to the invite page IF that is how 
        # they reached the site in the first place
         render :json => {
          cart: @cart
          user: @user
         }
      else
        render :json => {
          user: @user
        }   
      end
    else
      render :json => {
        error: "YOU FUCKED UP! YOU FUCKED UP!"
      }
    end
  end

  def update
    # @cart = Cart.find(session[:cart_id])
    @user = User.find(params[:id])
    # @user.password = SecureRandom.uuid
    @user.update_attributes(user_params)
    if @user.save
      # @cart = Cart.find(session[:cart_id])
      render :json => {
        user: @user.as_json(include: :carts)
      }
    else

    end
  end

end