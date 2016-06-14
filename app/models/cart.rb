class Cart < ActiveRecord::Base
  belongs_to :status
  has_many :cart_roles
  has_many :users, through: :cart_roles
  has_many :payments
  has_many :products
  has_many :notifications

  has_many :refunds, through: :payments

  validates :name, presence: true
  validates :minimum_payment, :numericality => true 
  validate :expiry_date_must_be_in_the_future
  
  # before_validation :convert_minimum_payment_to_cents


  def expiry_date_must_be_in_the_future 
    errors.add(:expiry, "must be in the future") if !expiry.blank? and expiry < Date.today
  end

  def total
    total = products.sum(:price) > 0 ? products.sum(:price) / 100.00 : 0
    "CDN$ #{total}"
  end

  private

  def convert_minimum_payment_to_cents
    (minimum_payment * 100).to_i
  end


end
