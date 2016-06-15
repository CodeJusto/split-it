class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 
  protect_from_forgery with: :exception

  protected

  def format_price(price)
    number_to_currency(price.to_i / 100.00, unit: "CDN$", format: "%u %n")
  end

  def convert_to_cents(num)
    (num.to_f * 100).to_i
  end

  def require_admin
    if !(current_user && current_user.final_boss?)
      flash[:alert] = "You are not an admin."
      redirect_to root_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_role(user, cart)
    # Returns the role of the user for the current cart
    user.roles.find_by('cart_roles.cart_id' => cart.id)
  end

  def user_notifications(user, cart)
    user.cart_roles.find_by('cart_roles.cart_id' => cart.id)
  end

  def find_role(role_id, medium)
    User.joins(:cart_roles).where('cart_roles.cart_id' => @cart_id, 'cart_roles.role_id' => role_id, "cart_roles.#{medium}_notifications" => true )  
  end
  
  helper_method :current_user, :format_price, :user_role, :user_notifications, :find_role
end


