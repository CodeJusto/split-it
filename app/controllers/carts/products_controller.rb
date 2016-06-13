class Carts::ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)


    if !get_amazon_product(@product).nil?
      amazon = get_amazon_product(@product)
      @product.image = amazon['ImageSets']['ImageSet'][0]['LargeImage']['URL']
      @product.price = amazon["OfferSummary"]["LowestNewPrice"]["Amount"]
      @product.description = amazon["ItemAttributes"]["Feature"].join(";")
      @product.price_checked_at = DateTime.now
      if @product.save
      redirect_to cart_path(params[:cart_id]), notice: "#{@product.display_name} was added successfully!"
      else
        render :new
      end
    else
      if @product.save
        redirect_to cart_path(params[:cart_id]), notice: "#{@product.display_name} was added successfully!"
      else
        render :new_full
      end
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

  def get_amazon_product(product)
    product.external_id = /\/(dp|gp\/product)\/(.+)\//.match(product.url)[2].to_s

    response = $amazon_request.item_lookup(
      query: {
        'ItemId' => product.external_id,
        'ResponseGroup' => 'ItemAttributes,Small,Images,OfferSummary'
      }
    )
    response.to_h["ItemLookupResponse"]["Items"]["Item"]
  end

end
