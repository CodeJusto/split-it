class NotificationTemplate < ActiveRecord::Base
  belongs_to :role
  has_many :notiications
end
