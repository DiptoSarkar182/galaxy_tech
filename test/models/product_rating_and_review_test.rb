require "test_helper"

class ProductRatingAndReviewTest < ActiveSupport::TestCase

  test 'product rating and review belongs to user' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    assert_not_nil product_review_1.user
  end

  test 'product rating and review belongs to product' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    assert_not_nil product_review_1.product
  end

  test 'product rating and review belongs to order' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    assert_not_nil product_review_1.order
  end

end
