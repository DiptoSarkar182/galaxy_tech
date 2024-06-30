require "test_helper"

class CartItemTest < ActiveSupport::TestCase

  test 'cart item should belong to cart' do
    cart_item_1 = cart_items(:johns_cart_item_1)
    cart_item_2 = cart_items(:johns_cart_item_2)
    assert_not_nil cart_item_1.cart
    assert_not_nil cart_item_2.cart
  end

  test 'cart item should belong to product' do
    cart_item_1 = cart_items(:johns_cart_item_1)
    cart_item_2 = cart_items(:johns_cart_item_2)
    assert_not_nil cart_item_1.product
    assert_not_nil cart_item_2.product
  end

  test 'cart item total price should be correct' do
    cart_item = cart_items(:johns_cart_item_1)
    expected_total = cart_item.product.price * cart_item.quantity
    assert_equal expected_total, cart_item.total_price
  end
end
