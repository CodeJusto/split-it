class AddTextNotification < ActiveRecord::Migration
  def change
    change_table :cart_roles do |t|
      t.boolean :text_notifications
    end

    rename_column :cart_roles, :notifications, :email_notifications
  end
end
