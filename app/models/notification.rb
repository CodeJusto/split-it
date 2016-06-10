class Notification < ActiveRecord::Base
  belongs_to :cart
  belongs_to :notification_template
end
