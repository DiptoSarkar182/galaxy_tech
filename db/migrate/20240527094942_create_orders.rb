class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'pending'
      t.decimal :total_price, precision: 9, scale: 2
      t.string :delivery_address, null: false
      t.string :payment_method, default: 'cash_on_delivery'
      t.uuid :order_number, default: "gen_random_uuid()", null: false
      t.timestamps
    end
    add_index :orders, :order_number, unique: true
  end
end
