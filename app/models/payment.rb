class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  has_one :refund
end
