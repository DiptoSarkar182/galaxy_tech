require "test_helper"

class ProductRatingsAndReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @product = products(:example_product_1)
    @order = orders(:johns_first_order)
    @order_item = order_items(:johns_order_item_1)
  end

  test "should get new for valid order and product without existing review" do
    sign_in @user
    get new_order_product_ratings_and_review_path(@order, product_id: @order_item )
    assert_response :success
  end

  # test "should redirect for invalid order or product" do
  #   get new_order_product_ratings_and_review_url, params: { order_id: "invalid", product_id: @product.id }
  #   assert_redirected_to orders_path
  #   assert_equal 'Invalid order or product.', flash[:alert]
  # end
  #
  # test "should redirect if review already exists" do
  #   # Create an existing review
  #   ProductRatingAndReview.create!(order: @order, product: @product, user: @user, rating: "4.5", review: "Great first product!")
  #
  #   get new_order_product_ratings_and_review_url, params: { order_id: @order.id, product_id: @product.id }
  #   assert_redirected_to orders_path
  #   assert_equal 'You have already rated this product for this order.', flash[:alert]
  # end
end
