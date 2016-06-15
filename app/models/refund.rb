class Refund < ActiveRecord::Base

  belongs_to :payment
  belongs_to :cart
  belongs_to :user

end
