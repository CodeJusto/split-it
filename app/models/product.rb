class Product < ActiveRecord::Base
  belongs_to :cart

  validates :display_name, presence: true
  validates :url, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :cart_id, presence: true

  private

  def amazon_url
    external_id = /\/(dp|gp\/product)\/(.+)\//.match(url)[2].to_s
    if external_id.nil?
      errors.add(:url, "is not a valid Amazon URL")
    end
  end
end
