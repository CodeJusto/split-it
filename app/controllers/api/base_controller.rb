class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  
  def current_user
    # binding.pry
    @current_user ||= User.find(1)
  end
end