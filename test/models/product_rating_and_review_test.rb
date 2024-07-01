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

  test 'product rating and review should save with user id' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    product_review_2 = product_rating_and_reviews(:johns_product_review_2)
    assert_not_nil product_review_1.user
    assert_not_nil product_review_2.user
  end

  test 'product rating and review should save with product id' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    product_review_2 = product_rating_and_reviews(:johns_product_review_2)
    assert_not_nil product_review_1.product
    assert_not_nil product_review_2.product
  end

  test 'product rating and review should save with order id' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    product_review_2 = product_rating_and_reviews(:johns_product_review_2)
    assert_not_nil product_review_1.order
    assert_not_nil product_review_2.order
  end

  test 'product rating and review should save with rating' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    product_review_2 = product_rating_and_reviews(:johns_product_review_2)
    assert_not_nil product_review_1.rating
    assert_not_nil product_review_2.rating
  end

  test 'product rating and review saves rating with precision 10 and scale 2' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    product_review_2 = product_rating_and_reviews(:johns_product_review_2)

    product_review_1.rating = 4.567
    product_review_2.rating = 3.789

    assert_equal 4.57, product_review_1.rating.to_f
    assert_equal 3.79, product_review_2.rating.to_f
  end

  test 'product rating and review cannot be saved without timestamps' do
    product_review_1 = product_rating_and_reviews(:johns_product_review_1)
    product_review_2 = product_rating_and_reviews(:johns_product_review_2)
    assert_not_nil product_review_1.created_at
    assert_not_nil product_review_1.updated_at
    assert_not_nil product_review_2.created_at
    assert_not_nil product_review_2.updated_at
  end

end
