class AmendPaymentsTable < ActiveRecord::Migration
  def change
     change_table :payments do |t|
      t.string :stripe_customer_id
      t.string :stripe_charge_id
    end
  end
end