class Carts::ProductsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session

  def create
    @product = Product.new(product_params)
    if @product.save
      render :json => {
        notice: "#{@product.display_name} was added successfully!"
        }
      redirect_to cart_path(params[:cart_id]), notice: "#{@product.display_name} was added successfully!"
    elsif @product.errors[:external_id].size > 0 || @product.errors[:description].size > 0 || @product.errors[:price].size > 0
      render :new_full
    else
      render :new
    end
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      redirect_to cart_path(params[:cart_id])
    else
      render :edit
    end
  end

  protected

  def product_params
    params.require(:product).permit(
      :display_name, :url, :quantity, :cart_id, :price, :price_checked_at, :description, :image
    )
  end

end