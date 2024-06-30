require "test_helper"

class OrderItemTest < ActiveSupport::TestCase

  test 'order items belong to order' do
    order_item_1 = order_items(:johns_order_item_1)
    assert_not_nil order_item_1.order
  end

  test 'order items belong to product' do
    order_item_1 = order_items(:johns_order_item_1)
    assert_not_nil order_item_1.product
  end

end
