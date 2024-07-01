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

  test 'user id cannot be null' do
    add_to_wish_list = AddToWishList.new(product_id: products(:example_product_1).id)
    assert_not add_to_wish_list.save
  end

  test 'product id cannot be null' do
    add_to_wish_list = AddToWishList.new(user_id: users(:john_doe).id)
    assert_not add_to_wish_list.save
  end

  test 'created at and updated at are set upon record creation' do
    add_to_wish_list = AddToWishList.create(user_id: users(:john_doe).id, product_id: products(:example_product_1).id)
    assert_not_nil add_to_wish_list.created_at
    assert_not_nil add_to_wish_list.updated_at
  end

end
