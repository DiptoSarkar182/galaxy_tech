require "test_helper"

class ProductTest < ActiveSupport::TestCase

  test 'product image size under limit validation' do
    product = Product.new
    big_file = StringIO.new('a' * (5.megabytes + 1))
    product.product_image.attach(io: big_file, filename: 'big_file.jpg', content_type: 'image/jpg')

    assert_not product.valid?
    assert_includes product.errors[:product_image], 'is too large (max is 5MB)'
    assert_not product.product_image.attached?
  end

  test 'product image must be an image file' do
    product = Product.new
    non_image_file = StringIO.new('This is not an image file')
    product.product_image.attach(io: non_image_file, filename: 'non_image_file.txt', content_type: 'text/plain')

    assert_not product.valid?
    assert_includes product.errors[:product_image], 'must be an image file'
    assert_not product.product_image.attached?
  end

  test 'product should save with diverse rich text formatting' do
    product = Product.new(name: "Feature-rich Product",
                          price: "29.99",
                          quantity: 30,
                          brand: "Advanced Brand")

    product.key_features = <<-HTML
      <strong>Bold</strong>, <em>Italic</em>, <s>Strikethrough</s>, <code>Code</code>,
      <ul>
        <li>Bullet List Item 1</li>
        <li>Bullet List Item 2</li>
      </ul>
      <ol>
        <li>Numbered List Item 1</li>
        <li>Numbered List Item 2</li>
      </ol>
      <a href='https://example.com'>Link</a>
    HTML

    product.specification = "<h1>Heading 1</h1><h2>Heading 2</h2><blockquote>Quote</blockquote>"
    product.description = "Combining <em>italic</em> and <strong>bold</strong> with <code>code</code>."

    assert product.save, "Failed to save product with diverse rich text formatting"
    assert product.key_features.body.to_html.include?('<strong>'), "Key features should include bold text"
    assert product.key_features.body.to_html.include?('<em>'), "Key features should include italic text"
    assert product.key_features.body.to_html.include?('<s>'), "Key features should include strikethrough text"
    assert product.key_features.body.to_html.include?('<code>'), "Key features should include code"
    assert product.key_features.body.to_html.include?('<ul>'), "Key features should include a bullet list"
    assert product.key_features.body.to_html.include?('<ol>'), "Key features should include a numbered list"
    assert product.key_features.body.to_html.include?('<a href='), "Key features should include a link"
    assert product.specification.body.to_html.include?('<h1>'), "Specification should include a heading"
    assert product.specification.body.to_html.include?('<blockquote>'), "Specification should include a blockquote"
    assert product.description.body.to_html.include?('<em>'), "Description should include italic text"
  end

  test "product has many cart items" do
    example_product = products(:example_product_1)
    assert_not example_product.cart_items.empty?, "Product should have associated cart items"
  end

  test "deleting product also deletes associated cart items" do
    example_product = products(:example_product_1)
    initial_cart_items_count = CartItem.count

    expected_cart_items_count_after_deletion = initial_cart_items_count - example_product.cart_items.count

    example_product.destroy
    assert_equal expected_cart_items_count_after_deletion, CartItem.count
  end

  test 'product has many order items' do
    product = products(:example_product_1)
    assert_not product.order_items.empty?
  end

  test "deleting product also deletes associated order items" do
    product = products(:example_product_1)
    assert_difference('OrderItem.count', -product.order_items.count) do
      product.destroy
    end
  end

  test 'product has many rating and reviews' do
    product = products(:example_product_1)
    assert_not product.product_rating_and_reviews.empty?
  end

  test "deleting product also deletes product rating and reviews" do
    product = products(:example_product_1)
    assert_difference('ProductRatingAndReview.count', -product.product_rating_and_reviews.count) do
      product.destroy
    end
  end

  test 'product has many add to wishlists' do
    product = products(:example_product_1)
    assert_not product.add_to_wish_lists.empty?
  end

  test "deleting product also deletes product add to wishlist" do
    product = products(:example_product_1)
    assert_difference('AddToWishList.count', -product.add_to_wish_lists.count) do
      product.destroy
    end
  end

end
