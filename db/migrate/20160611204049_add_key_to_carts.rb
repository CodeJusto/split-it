class AddKeyToCarts < ActiveRecord::Migration
  def change
    change_table :carts do |t|
      t.string :key
    end
  end
end
