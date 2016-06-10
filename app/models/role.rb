class Role < ActiveRecord::Base
  has_many :cart_roles
  has_many :notification_templates
end
