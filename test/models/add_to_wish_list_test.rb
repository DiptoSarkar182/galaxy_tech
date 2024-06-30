require "test_helper"

class AddToWishListTest < ActiveSupport::TestCase

  test "add to wishlist should belong to a user" do
    wish_list_item = add_to_wish_lists(:example_wish_list_1)
    assert_not_nil wish_list_item.user
    assert_equal wish_list_item.user, users(:john_doe)
  end

  test 'add to wishlist should belong to product' do
    wish_list_item = add_to_wish_lists(:example_wish_list_1)
    assert_not_nil wish_list_item.product
    assert_equal wish_list_item.product, products(:example_product_1)
  end

end
