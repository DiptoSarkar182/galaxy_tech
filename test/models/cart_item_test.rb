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

  test 'cart id cannot be null' do
    cart_item = CartItem.new(product_id: products(:example_product_1).id, quantity: 1)
    assert_not cart_item.save
  end

  test 'product id cannot be null' do
    cart_item = CartItem.new(cart_id: carts(:johns_cart),quantity: 1)
    assert_not cart_item.save
  end

  test 'quantity cannot be null and default value should be 1' do
    cart_item_with_default_quantity = CartItem.create(cart_id: carts(:johns_cart).id, product_id: products(:example_product_1).id)
    assert_equal 1, cart_item_with_default_quantity.quantity
  end

  test 'created at and updated at are set upon record creation' do
    cart_item = CartItem.create(cart_id: carts(:johns_cart).id, product_id: products(:example_product_1).id, quantity: cart_items(:johns_cart_item_1).quantity)
    assert_not_nil cart_item.created_at
    assert_not_nil cart_item.updated_at
  end
end
