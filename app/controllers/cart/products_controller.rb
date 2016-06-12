class Cart::ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    @product.external_id = /\/product\/(.+)\//.match(@product.url)[1].to_s

    if @product.save
      redirect_to cart_path(params[:product][:cart_id]), notice: "#{@product.display_name} was added successfully!"
    else
      render :new
    end
  end

  def update
  end

  def destroy
  end

  protected

  def product_params
    params.require(:product).permit(
      :display_name, :url, :quantity, :cart_id
    )
  end

end
