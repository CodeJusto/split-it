class Carts::ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to cart_path(params[:cart_id]), notice: "#{@product.display_name} was added successfully!"
    elsif @product.errors[:external_id]
      render :new_full
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      redirect_to cart_path(params[:cart_id])
    else
      render :edit
    end
  end

  def destroy
    @product = Product.destroy(params[:id])
    redirect_to cart_path(params[:cart_id])
  end

  protected

  def product_params
    params.require(:product).permit(
      :display_name, :url, :quantity, :cart_id, :price, :price_checked_at, :description, :image
    )
  end

end
