class AddRefundsTable < ActiveRecord::Migration
  def change
    remove_column :payments, :status

    create_table :refunds do |t|
      t.references :user
      t.references :cart
      t.references :payment
      t.integer :amount
      t.string :stripe_customer_id
      t.string :stripe_charge_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
