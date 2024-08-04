require "test_helper"

class ProductRatingsAndReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @product = products(:example_product_1)
    @order = orders(:johns_first_order)
    @order_item = order_items(:johns_order_item_1)
    @existing_review = product_rating_and_reviews(:johns_product_review_1)
    ProductRatingAndReview.where(order: @order, product: @product, user: @user).destroy_all
  end

  test "should get new for valid order and product without existing review" do
    sign_in @user
    @order.update(status: 'delivered')
    get new_order_product_ratings_and_review_path(@order, product_id: @order_item.product.id)

    assert_response :success
    assert_not_nil assigns(:product_rating_and_review)
  end

  test "should redirect for invalid order" do
    sign_in @user
    get new_order_product_ratings_and_review_path(order_id: -1, product_id: @order_item.product.id)
    assert_redirected_to orders_path
    assert_equal 'Invalid order or product.', flash[:alert]
  end

  test "should redirect for invalid product" do
    sign_in @user
    get new_order_product_ratings_and_review_path(@order, product_id: -1)
    assert_redirected_to orders_path
    assert_equal 'Invalid order or product.', flash[:alert]
  end

  test "should redirect if review already exists" do
    sign_in @user
    @order.update(status: 'delivered')
    ProductRatingAndReview.create!(user: @user, order: @order, product: @order_item.product, rating: 4.5, review: "Existing review")

    get new_order_product_ratings_and_review_path(@order, product_id: @order_item.product.id)
    assert_redirected_to order_path(@order)
    assert_equal 'You have already rated this product for this order.', flash[:alert]
  end

  test "should redirect if order is not delivered" do
    sign_in @user
    @order.update(status: 'processing')
    get new_order_product_ratings_and_review_path(@order, product_id: @order_item.product.id)
    assert_redirected_to order_path(@order)
    assert_equal 'You can only rate and review delivered orders.', flash[:alert]
  end

  test "should create review for delivered order" do
    user = User.create!(
      email: 'john@example.com',
      password: 'password',
      full_name: 'John Doe',
      confirmed_at: Time.now
    )

    product = Product.create!(
      name: 'Example Product',
      price: 19.99,
      quantity: 10,
      brand: 'Example Brand',
      key_features: 'Feature 1, Feature 2',
      specification: 'Spec 1, Spec 2',
      description: 'An example product',
      component: 'Component 1'
    )

    order = Order.create!(
      user: user,
      status: 'delivered',
      total_price: 19.99,
      delivery_address: '123 Example St, City',
      payment_method: 'cash_on_delivery',
      order_number: SecureRandom.uuid
    )

    sign_in user
    assert_difference('ProductRatingAndReview.count', 1) do
      post order_product_ratings_and_reviews_path(order), params: {
        product_rating_and_review: {
          user_id: user.id,
          order_id: order.id,
          product_id: product.id,
          rating: 5,
          review: 'Great product!'
        }
      }
    end

    assert_redirected_to order_path(order)
    assert_equal 'Review was successfully created.', flash[:notice]
  end

  test "should not update review if not owned by user" do
    user = User.create!(
      email: 'john@example.com',
      password: 'password',
      full_name: 'John Doe',
      confirmed_at: Time.now
    )

    other_user = User.create!(
      email: 'jane@example.com',
      password: 'password',
      full_name: 'Jane Doe',
      confirmed_at: Time.now
    )

    product = Product.create!(
      name: 'Example Product',
      price: 19.99,
      quantity: 10,
      brand: 'Example Brand',
      key_features: 'Feature 1, Feature 2',
      specification: 'Spec 1, Spec 2',
      description: 'An example product',
      component: 'Component 1'
    )

    order = Order.create!(
      user: other_user,
      status: 'delivered',
      total_price: 19.99,
      delivery_address: '123 Example St, City',
      payment_method: 'cash_on_delivery',
      order_number: SecureRandom.uuid
    )

    review = ProductRatingAndReview.create!(
      user: other_user,
      order: order,
      product: product,
      rating: 4,
      review: 'Good product'
    )

    sign_in user

    patch order_product_ratings_and_review_path(order, review), params: {
      product_rating_and_review: {
        rating: 5,
        review: 'Updated review'
      }
    }

    assert_redirected_to orders_path
    assert_equal 'You are not authorized to update this review.', flash[:alert]
  end


end
