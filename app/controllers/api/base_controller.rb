class Api::BaseController < ApplicationController

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  
  def current_user
    @current_user ||= User.find(params[:id]) unless params[:id].nil?
  end
end