class Cart < ActiveRecord::Base
  belongs_to :status

  has_many :cart_roles
  has_many :users, through: :cart_roles
  has_many :roles, through: :cart_roles
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

  def find_role(role_id, medium)
    User.joins(:cart_roles).where('cart_roles.cart_id' => @cart_id, 'cart_roles.role_id' => role_id, "cart_roles.#{medium}_notifications" => true )  
  end

  def organizer
    users.where('cart_roles.cart_id' => id, 'cart_roles.role_id' => 1)
  end

  def check_status
    @cart = self
    organizer_email = find_role(1, "email")
    contributor_email = find_role(2, "email")

    organizer_text = find_role(1, "text")
    contributor_text = find_role(2, "text")

    if status.id == 1 && products.size > 0
      update_attribute(:status_id, 2)
    elsif status.id == 2 && progress == 100
      update_attribute(:status_id, 4)
      Notification.create(cart_id: @cart_id, notification_template_id: 3)
      unless contributor_email.empty?
        contributor_email.each do |c|
          cart_complete(organizer_email, c, @cart).deliver_now
        end
      end

      unless contributor_text.empty?
        contributor_text.each do |text|
           $twilio.account.sms.messages.create(
            :from => ENV['COMPANY_PHONE'],
            :to => "+1#{text.number}",
            :body => "#{@cart.name} has reached its goal!!"
          )
        end
      end

    elsif status.id == 2 && progress < 100 && expiry > Date.today
      update_attribute(:status_id, 3)
      Notification.create(cart_id: @cart_id, notification_template_id: 4)
      unless contributor_email.empty?
        contributor_email.each do |c|
          cart_failure(organizer_email, c, @cart).deliver_now
        end
      end
    
      unless contributor_text.empty?
        contributor_text.each do |text|
           $twilio.account.sms.messages.create(
            :from => ENV['COMPANY_PHONE'],
            :to => "+1#{text.number}",
            :body => "#{@cart.name} did not reach its target goal!"
          )
        end
      end

    end
  end

  # def as_json(options={})
  #   super()
  # end

end
