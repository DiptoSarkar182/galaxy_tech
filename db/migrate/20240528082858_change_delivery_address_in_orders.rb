class ChangeDeliveryAddressInOrders < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :delivery_address, :text
  end
end
