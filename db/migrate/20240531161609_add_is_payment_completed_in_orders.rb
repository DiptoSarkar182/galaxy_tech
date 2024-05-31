class AddIsPaymentCompletedInOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :is_payment_completed, :boolean, default: false
  end
end
