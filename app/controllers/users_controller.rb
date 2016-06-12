class UsersController < ApplicationController
  def index
    @cart = Cart.new
    @user = User.new
    @all = Cart.all # Remove later
  end

  def create
  end

  def update
  end

  def destroy
  end
end
