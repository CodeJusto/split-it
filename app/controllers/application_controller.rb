class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 
  protect_from_forgery with: :exception

  def format_price(price)
    number_to_currency(price.to_i / 100.00, unit: "CDN$", format: "%u %n")
  end

  def convert_to_cents(num)
    (num.to_f * 100).to_i
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user, :format_price
end


