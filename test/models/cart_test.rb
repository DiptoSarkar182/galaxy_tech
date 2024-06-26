require "test_helper"

class CartTest < ActiveSupport::TestCase
  test 'cart should belong to user' do
    cart = carts(:johns_cart)
    assert_not_nil cart.user
    assert_equal cart.user, users(:john_doe)
  end

  test 'cart should have many cart items' do
    cart = carts(:johns_cart)
    assert_not cart.cart_items.empty?
  end

  test "deleting cart also deletes associated cart items" do
    cart = carts(:johns_cart)
    assert_difference('CartItem.count', -cart.cart_items.count) do
      cart.destroy
    end
  end

  test 'carts total price is correct' do
    cart = carts(:johns_cart)
    expected_total = cart_items(:johns_cart_item_1).quantity * products(:example_product_1).price +
      cart_items(:johns_cart_item_2).quantity * products(:example_product_2).price
    assert_equal expected_total, cart.total_price
  end

  test 'user id cannot be null' do
    cart = Cart.new(user_id: nil)
    assert_not cart.save
  end

  test 'created at and updated at are set upon record creation' do
    cart = Cart.create(user_id: users(:john_doe).id)
    assert_not_nil cart.created_at
    assert_not_nil cart.updated_at
  end
end
