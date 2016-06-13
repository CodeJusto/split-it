class Cart < ActiveRecord::Base
  belongs_to :status
  has_many :cart_roles
  has_many :users, through: :cart_roles
  has_many :payments
  has_many :products
  has_many :notifications

  validates :name, presence: true
  validates :minimum_payment, numericality: { only_integer: true }
  validate :expiry_date_must_be_in_the_future

  def expiry_date_must_be_in_the_future 
    errors.add(:expiry, "must be in the future") if !expiry.blank? and expiry < Date.today
  end

  def cart_total
    product_ids = products.inject([]) { |arr, product| arr.push(product.external_id)  } 

    response = $amazon_request.item_lookup(
      query: {
        'ItemId' => product_ids.join(','),
        'ResponseGroup' => 'OfferSummary'
      }
    )

    return 0.00 if response.to_h["ItemLookupResponse"]["Items"]["Item"].nil?
    items = product_ids.size >= 2 ? response.to_h["ItemLookupResponse"]["Items"]["Item"] : [response.to_h["ItemLookupResponse"]["Items"]["Item"]]
    total = items.inject(0) { |sum, item| sum + item["OfferSummary"]["LowestNewPrice"]["Amount"].to_i * products.find_by(external_id: item["ASIN"]).quantity } / 100.00
  end


end
