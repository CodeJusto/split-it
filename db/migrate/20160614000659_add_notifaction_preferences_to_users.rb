class AddNotifactionPreferencesToUsers < ActiveRecord::Migration
  def change
    change_table :cart_roles do |t|
      t.boolean :notifications
    end
  end
end
