class Product < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["name", "price", "component", "brand", "quantity", "created_at", "updated_at"]
  end

  validates :product_image, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :brand, presence: true
  validates :component, presence: true

  validate :product_image_size_under_limit
  validate :product_image_must_be_image

  has_rich_text :key_features
  has_rich_text :specification
  has_rich_text :description
  has_one_attached :product_image

  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :product_rating_and_reviews, dependent: :destroy
  has_many :add_to_wish_lists, dependent: :destroy
  has_many :users, through: :add_to_wish_lists

  before_destroy :purge_product_image
  before_update :purge_product_image, if: :product_image_changed?

  private
  def product_image_size_under_limit
    if product_image.attached? && product_image.blob.byte_size > 5.megabytes
      product_image.purge
      errors.add(:product_image, 'is too large (max is 5MB)')
    end
  end

  def product_image_must_be_image
    if product_image.attached? && !product_image.content_type.start_with?('image/')
      product_image.purge
      errors.add(:product_image, 'must be an image file')
    end
  end

  def purge_product_image
    if Rails.env.production?
      public_id = "ruby_on_rails/galaxy_tech/#{product_image.key}"
      Cloudinary::Api.delete_resources([public_id], type: :upload, resource_type: :image)
    end
  end

  def product_image_changed?
    product_image.attached? && product_image.attachment.blob_id_changed?
  end



end
