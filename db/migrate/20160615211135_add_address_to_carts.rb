class AddAddressToCarts < ActiveRecord::Migration
  def change
    change_table :carts do |t|
      t.string :country
      t.string :street_address
      t.string :street_address2
      t.string :city
      t.string :province
      t.string :zip_code
    end
  end
end
