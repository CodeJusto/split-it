class Cart < ActiveRecord::Base
  belongs_to :status
  has_many :cart_roles
  has_many :users, through: :cart_roles
  has_many :payments
  has_many :products
  has_many :notifications
end
