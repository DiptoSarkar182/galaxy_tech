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

  test 'order item cannot be saved without order_id' do
    order_item = order_items(:johns_order_item_1)
    assert_not_nil order_item.order
  end

  test 'order item cannot be saved without product_id' do
    order_item = order_items(:johns_order_item_1)
    assert_not_nil order_item.product
  end

  test 'order item cannot be saved without quantity' do
    order_item = order_items(:johns_order_item_1)
    assert_not_nil order_item.quantity
  end

  test 'order item cannot be saved without price' do
    order_item = order_items(:johns_order_item_1)
    assert_not_nil order_item.price
  end

  test 'order item cannot be saved without timestamps' do
    order_item = order_items(:johns_order_item_1)
    assert_not_nil order_item.created_at
    assert_not_nil order_item.updated_at
  end

end
