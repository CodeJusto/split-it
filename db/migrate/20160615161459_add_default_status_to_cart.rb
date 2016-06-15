class AddDefaultStatusToCart < ActiveRecord::Migration
  change_column(:carts, :status_id, :integer, default: 1)
end
