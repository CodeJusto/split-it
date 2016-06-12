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


end
