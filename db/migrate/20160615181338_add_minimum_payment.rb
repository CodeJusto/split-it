class AddMinimumPayment < ActiveRecord::Migration
  def change
    add_column :carts, :custom_minimum_payment, :integer
  end
end
