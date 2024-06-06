class AddStripeChargeIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :stripe_charge_id, :string
  end
end
