class CartRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  belongs_to :role
end
