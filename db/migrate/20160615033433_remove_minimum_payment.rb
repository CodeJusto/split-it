class RemoveMinimumPayment < ActiveRecord::Migration
  def change

  remove_column :carts, :minimum_payment

  end
end
