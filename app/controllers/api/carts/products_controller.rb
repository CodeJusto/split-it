class Api::Carts::ProductsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  protect_from_forgery with: :null_session

  def create
    @product = Product.new(
      display_name: params[:display_name],
      url: params[:url],
      quantity: params[:quantity],
      cart_id: params[:cart_id]
      )
    if @product.save
      render :json => {
        notice: "#{@product.display_name} was added successfully!"
        }
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

  # def product_params
  #   params.require(:product).permit(
  #     :display_name, :url, :quantity, :cart_id
  #   )
  # end

end