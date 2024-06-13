class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :product_rating_and_reviews, dependent: :destroy
end
