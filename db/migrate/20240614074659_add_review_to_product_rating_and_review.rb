class AddReviewToProductRatingAndReview < ActiveRecord::Migration[7.1]
  def change
    add_column :product_rating_and_reviews, :review, :text
  end
end
