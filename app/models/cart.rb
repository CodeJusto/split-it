class Cart < ActiveRecord::Base
  belongs_to :status
  has_many :cart_roles
  has_many :users, through: :cart_roles
  has_many :payments
  has_many :products
  has_many :notifications

  validates :name, presence: true
  validate :expiry_date_must_be_in_the_future

  before_save :convert_minimum_payment_to_cents

  def expiry_date_must_be_in_the_future 
    errors.add(:expiry, "must be in the future") if !expiry.blank? and expiry < Date.today
  end

  def cart_total
    
    total = products.sum(:price) > 0 ? products.sum(:price) / 100.00 : 0
    "CDN$ #{total}"
  end

  private

  def convert_minimum_payment_to_cents
    (minimum_payment * 100).to_i
  end


end
