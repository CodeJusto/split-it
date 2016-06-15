class Admin::CartsController < ApplicationController

  before_filter :require_admin

  def index
    @carts = Cart.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @carts }
    end
  end

end