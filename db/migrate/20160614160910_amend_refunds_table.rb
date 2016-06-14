class AmendRefundsTable < ActiveRecord::Migration
  def change
    change_table :refunds do |t|
      t.references :payment
    end
  end
end
