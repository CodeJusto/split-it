class User < ActiveRecord::Base
  has_many :cart_roles
  has_many :payments
end
