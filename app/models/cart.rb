class Cart < ActiveRecord::Base
  belongs_to :status

  has_many :cart_roles
  has_many :users, through: :cart_roles
  has_many :payments
  has_many :products
  has_many :notifications

  has_many :refunds, through: :payments


  validates :name, presence: true
  # validates :minimum_payment, :numericality => true 
  validate :expiry_date_must_be_in_the_future
  

  def expiry_date_must_be_in_the_future 
    errors.add(:expiry, "must be in the future") if !expiry.blank? and expiry < Date.today
  end

  def total
    products.sum("price * quantity")
  end

  def total_payment
    # total = Payment.joins("LEFT JOIN refunds ON refunds.payment_id = payments.id WHERE refunds.payment_id IS NULL AND payments.cart_id = ?", id)
    total = Payment.includes(:refund).where(refunds: { payment_id: nil }).where("payments.cart_id = ?", id).sum(:amount)
    total == 0 ? 0 : total
  end

  def progress
    total == 0 ? 0 : ((total_payment.to_f / total.to_f) * 100).ceil
  end

  def check_status
    if status.id == 1 && products.size > 0
      update_attribute(:status_id, 2)
    elsif status.id == 2 && progress == 100
      update_attribute(:status_id, 4)
    end
  end


  def refund_expired_carts
    @expired_carts = Cart.where(:expiry < Date.now)

  end


end
