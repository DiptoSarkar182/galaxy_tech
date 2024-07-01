require "test_helper"

class OrderTest < ActiveSupport::TestCase

  test 'order should belong to user' do
    order = orders(:johns_first_order)
    assert_not_nil order.user
    assert_equal order.user, users(:john_doe)
  end

  test 'order has many order items' do
    order_1 = orders(:johns_first_order)
    order_2 = orders(:johns_second_order)
    assert order_1.order_items.count > 0, "Order 1 should have at least one order item"
    assert order_2.order_items.count > 0, "Order 2 should have at least one order item"
  end

  test 'order item should destroy when order is destroyed' do
    order = orders(:johns_first_order)
    order_items_count_before_destroy = order.order_items.count

    assert_difference 'OrderItem.count', -order_items_count_before_destroy do
      order.destroy
    end
  end

  test 'order has many product rating and reviews' do
    order_1 = orders(:johns_first_order)
    order_2 = orders(:johns_second_order)
    assert_not order_1.product_rating_and_reviews.empty?
    assert_not order_2.product_rating_and_reviews.empty?

    review_1 = order_1.product_rating_and_reviews.first
    assert_equal BigDecimal("4.5"), review_1.rating
    assert_equal "Great first product!", review_1.review

    review_2 = order_2.product_rating_and_reviews.first
    assert_equal BigDecimal("3.3"), review_2.rating
    assert_equal "Great second product!", review_2.review
  end

  test 'order cannot be saved without a user' do
    order = orders(:johns_first_order)
    assert_not_nil order.user
  end

  test 'order saves with default pending status' do
    order = orders(:johns_first_order)
    assert_equal "pending", order.status
  end

  test 'order saves total_price with precision 9 and scale 2' do
    order = orders(:johns_first_order)
    order.total_price = 1234567.891
    assert_equal 1234567.89, order.total_price
  end

  test 'order saves with default payment method cash on delivery' do
    order = orders(:johns_first_order)
    assert_equal "cash_on_delivery", order.payment_method
  end

  test 'order saves with order number which is random generated uuid' do
    order = orders(:johns_first_order)
    assert_not_nil order.order_number
    assert_match /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i, order.order_number
  end

  test 'order cannot be saved without timestamps' do
    order = orders(:johns_first_order)
    assert_not_nil order.created_at
    assert_not_nil order.updated_at
  end

  test 'order saves with default is payment completed false' do
    order = orders(:johns_first_order)
    assert_equal false, order.is_payment_completed
  end

end
