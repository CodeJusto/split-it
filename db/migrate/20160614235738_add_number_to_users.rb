class AddNumberToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :number
    end
  end
end
