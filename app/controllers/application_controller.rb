class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 
  protect_from_forgery with: :exception

  def format_price(price)
    number_to_currency(price.to_i / 100.00, unit: "CDN$", format: "%u %n")
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_role(user, cart)
    # Returns the role of the user for the current cart
    user.roles.find_by('cart_roles.cart_id' => cart.id)
  end

  def user_notifications(user, cart)
    user.cart_roles.find_by('cart_roles.cart_id' => cart.id).notifications
  end
  
  helper_method :current_user, :format_price, :user_role, :user_notifications
end


