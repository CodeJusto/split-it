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
  


  def expiry_date_must_be_in_the_future 
    errors.add(:expiry, "must be in the future") if !expiry.blank? and expiry < Date.today
  end

  def total
    products.sum("price * quantity")
  end


end
