class Admin::UsersController < ApplicationController

  before_filter :require_admin

  def index
    @users = User.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

 def remove
  @user = User.find(params[:id])
  @cart = Cart.find(params[:cart_id])
  deleted_user = CartRole.find_by(user_id: @user.id, cart_id: @cart.id)
  if deleted_user.destroy
    Notifications.delete_contributor(@user, @cart).deliver_now
    # Do we need to create a notification row for this?
  end
  redirect_to cart_path(@cart)
  end

  def invite
    @inviter = current_user
    @cart = Cart.find(params[:cart_id])
    @emails = params[:emails]
    @emails.each do |key, email|
      # binding.pry
      Notifications.invite_contributor(@inviter, @cart, email).deliver_now
      # Do we need to create a notification row for this?
    end
    redirect_to root_path
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end