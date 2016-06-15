class Product < ActiveRecord::Base
  belongs_to :cart

  validates :display_name, presence: true
  validates :url, presence: true
  validates :quantity, presence: true
  validates :price, presence: true, unless: :form_check?
  validates :description, presence: true, unless: :form_check?
  validates :cart_id, presence: true


  before_validation :get_amazon_data, if: :form_check? && :amazon_url && :amazon_api
  before_validation :clear_error, unless: :form_check?

  private

  def amazon_url
    match = /www\.?amazon.ca/.match(url)
    if match.nil?
      return false
    else
      return true
    end
  end

  def amazon_api
    match = /\/(dp|gp\/product)\/(\w+)\/?/.match(url)
    if amazon_url && match.size >=3
      external_id = match[2].to_s
    else
      errors.add(:url, "is not a valid Amazon URL")
      return false
    end

    @response = get_amazon_response(external_id)

    if @response.nil?
      errors.add(:external_id, " ID is not an accessible Amazon ASIN")
      return false
    else
      return true
    end
  end

  def get_amazon_response(id)
    $amazon_request.item_lookup(
      query: {
        'ItemId' => id,
        'ResponseGroup' => 'ItemAttributes,Small,Images,OfferSummary'
      }
    ).to_h["ItemLookupResponse"]["Items"]["Item"]
  end

  def get_amazon_data
    if @response['ImageSets']['ImageSet'].is_a?(Array)
      self.image = @response['ImageSets']['ImageSet'][0]['LargeImage']['URL']
    else
      self.image = @response['ImageSets']['ImageSet']['LargeImage']['URL']
    end
    self.price = @response["OfferSummary"]["LowestNewPrice"]["Amount"]
    if @response["ItemAttributes"]["Feature"].is_a?(Array)
      self.description = @response["ItemAttributes"]["Feature"].join(";")
    else
      self.description = @response["ItemAttributes"]["Feature"]
    end
    self.price_checked_at = DateTime.now
  end

  def form_check?
    price.nil? && description.nil?
  end

  def clear_error
    errors.clear
  end

end
