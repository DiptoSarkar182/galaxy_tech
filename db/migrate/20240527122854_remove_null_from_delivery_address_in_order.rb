class RemoveNullFromDeliveryAddressInOrder < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orders, :delivery_address, true
  end
end
