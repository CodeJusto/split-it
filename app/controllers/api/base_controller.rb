class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token
  
  def current_user
    @current_user ||= User.find(params[:id])
  end
end