class DefaultEmailTextSettings < ActiveRecord::Migration
  def change
      change_column_default(:cart_roles, :email_notifications, true)
      change_column_default(:cart_roles, :text_notifications, true)
  end
end
