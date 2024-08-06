require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:john_doe)
    @admin = users(:admin)
    @cart = carts(:johns_cart)
    @cart_item_1 = cart_items(:johns_cart_item_1)
    @cart_item_2 = cart_items(:johns_cart_item_2)
    @order = orders(:johns_first_order)
    @other_user = User.create!(email: 'jane_doe@example.com', password: 'password', address: '123 Other St', full_name: "Jane")
    @other_order = Order.create!(user: @other_user, delivery_address: @other_user.address, payment_method: 'cash_on_delivery', total_price: 100, status: 'processing', delivery_method: 'store_pickup')

    sign_in @user
  end

  test "should redirect admin user with access denied alert" do
    sign_in @admin
    get orders_url
    assert_redirected_to root_path
    assert_equal 'Access denied!', flash[:alert]
  end

  test "should get index for regular user" do
    sign_in @user
    get orders_url
    assert_response :success
    assert_not_nil assigns(:orders)
    assert_equal @user.orders.order(created_at: :desc), assigns(:orders)
  end

  test "should create order with store_pickup and cash_on_delivery" do
    assert_difference('Order.count', 1) do
      assert_difference('OrderItem.count', 2) do
        post orders_url, params: {
          user: { address: @user.address },
          delivery_method: 'store_pickup',
          payment_method: 'cash_on_delivery'
        }
      end
    end

    assert_redirected_to carts_path
    assert_equal 'Order was successfully created.', flash[:notice]
  end

  test "should create order with home_delivery and online_payment" do
    assert_difference('Order.count', 1) do
      assert_difference('OrderItem.count', 2) do
        post orders_url, params: {
          user: { address: @user.address },
          delivery_method: 'home_delivery',
          payment_method: 'online_payment'
        }
      end
    end

    order = Order.last
    assert_redirected_to stripe_payment_order_path(order)
    assert_equal 'Your order is awaiting payment confirmation.', flash[:notice]
  end

  test "should fail to create order with invalid data" do
    skip "Skipping this test for now"
    assert_no_difference('Order.count') do
      post orders_url, params: {
        user: { address: '' },
        delivery_method: 'store_pickup',
        payment_method: 'cash_on_delivery'
      }
    end

    assert_template :new
    assert_equal 'Failed to create order: Validation failed: Address can\'t be blank', flash[:error]
  end

  test "should show order for the current user" do
    get order_url(@order)
    assert_response :success
    assert_not_nil assigns(:order)
    assert_equal @order, assigns(:order)
    assert_not_nil assigns(:product_ids_with_reviews)
  end

  test "should not show order for a different user" do
    get order_url(@other_order)
    assert_redirected_to orders_path
    assert_equal 'You are not authorized to view this order.', flash[:alert]
  end

end
