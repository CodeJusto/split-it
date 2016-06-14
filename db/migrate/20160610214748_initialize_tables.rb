class InitializeTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :final_boss, default: false
    end

    create_table :payments do |t|
      t.references :user
      t.references :cart
      t.string :status
      t.integer :amount
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :carts do |t|
      t.references :status
      t.datetime :expiry
      t.integer :minimum_payment
      t.string :name
      t.integer :total_paid
      t.integer :target_amount
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :statuses do |t|
      t.string :text
    end

    create_table :products do |t|
      t.references :cart
      t.string :url
      t.string :display_name
      t.string :external_id
      t.integer :quantity
      t.datetime :created_at
      t.datetime :updated_at      
    end

    create_table :notifications do |t|
      t.references :cart
      t.references :notification_template
      t.datetime :created_at
    end

    create_table :notification_templates do |t|
      t.references :role
      t.text :email_text
      t.text :ui_text
      t.string :description
    end

    create_table :roles do |t|
      t.string :role_text
    end

    create_table :cart_roles do |t|
      t.references :user
      t.references :cart
      t.references :role
    end
  end
end
