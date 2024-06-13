class CreateProductRatingAndReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :product_rating_and_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :order, null: true, foreign_key: true
      t.decimal :rating, null:false, precision: 10, scale: 2
      t.timestamps
    end
  end
end
