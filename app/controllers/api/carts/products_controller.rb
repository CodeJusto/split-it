class Api::Carts::ProductsController < ApplicationController

  skip_before_filter :verify_authenticity_token
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def create
    @product = Product.new(
      display_name: params[:display_name],
      url: params[:url],
      quantity: params[:quantity],
      cart_id: params[:id]
      )
    if @product.save
      render :json => {success: "#{@product.display_name} was added successfully!"}.to_json, status: 200
    else @product.errors[:external_id].size > 0 || @product.errors[:description].size > 0 || @product.errors[:price].size > 0
      render :json => {error: @product.errors}.to_json, status: 400
    end
  end

  # def update
  #   @product = Product.find(params[:id])

  #   if @product.update_attributes(product_params)
  #     redirect_to cart_path(params[:cart_id])
  #   else
  #     render :edit
  #   end
  # end

  protected

  # def product_params
  #   params.require(:product).permit(
  #     :display_name, :url, :quantity, :cart_id
  #   )
  # end

end