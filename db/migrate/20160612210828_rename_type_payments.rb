class RenameTypePayments < ActiveRecord::Migration
  def change
    rename_column :payments, :type, :status
  end
end
