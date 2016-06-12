class AddTypePaymentsTable < ActiveRecord::Migration
  def change
    remove_column :payments, :captured

    change_table :payments do |t|
      t.string :type, default: "paid"
    end
  end
end