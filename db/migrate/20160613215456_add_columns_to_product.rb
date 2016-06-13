class AddColumnsToProduct < ActiveRecord::Migration
  change_table :products do |t|
    t.integer :price
    t.string :image
    t.string :description
    t.timestamp :price_checked_at
  end
end
