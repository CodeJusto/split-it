class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 
  protect_from_forgery with: :exception

  def format_price(price)
    dollar = price.to_i > 0 ? price / 100.00 : 0
    "CDN$ #{dollar}"
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user, :format_price
end


