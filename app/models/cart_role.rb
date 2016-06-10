class CartRole < ActiveRecord::Base
  belongs_to :users
  belongs_to :carts
  belongs_to :roles
end
