class AddNullFalseToProductRatingAndReviews < ActiveRecord::Migration[7.1]
  def change
    change_column_null :product_rating_and_reviews, :order_id, false
  end
end
