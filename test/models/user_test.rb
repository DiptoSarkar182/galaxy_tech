require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:john_doe)
  end


  test "should be valid" do
    assert @user.valid?
  end

  test "full_name should be present" do
    @user.full_name = " "
    assert_not @user.valid?
  end

  test "full_name should not be too short" do
    @user.full_name = "a" * 2
    assert_not @user.valid?
  end

  test "full_name should not be too long" do
    @user.full_name = "a" * 101
    assert_not @user.valid?
  end

  test "full_name should be alphabetic" do
    @user.full_name = "John3 Doe"
    assert_not @user.valid?
  end

  test 'email should be present' do
    user = User.new(password: 'password123', password_confirmation: 'password123')
    assert_not user.save, 'Saved the user without an email'
  end

  test "admin? should return false for non-admin user" do
    assert_not @user.admin?
  end


  test "name must be alphabetic" do
    @user.full_name = "123"
    assert_not @user.valid?, "Name contains non-alphabetic characters but was still valid"
  end

  test "full_name is formatted before validation" do
    @user.full_name = "  john   doe  "
    @user.valid?
    assert_equal "John Doe", @user.full_name, "full_name was not properly formatted"
  end

  test "full_name is titleized before validation" do
    @user.full_name = "john doe"
    @user.valid?
    assert_equal "John Doe", @user.full_name, "full_name was not properly titleized"
  end

  test "full_name formatting with mixed case" do
    @user.full_name = "jOhN dOe"
    puts "Before validation: #{@user.full_name}"
    @user.valid?
    puts "After validation: #{@user.full_name}"
    assert_equal "John Doe", @user.full_name, "full_name was not properly titleized and formatted"
  end

  test 'user has one cart' do
    user = users(:john_doe)
    assert_not_nil user.cart
  end

  test 'users cart is destroyed when user is destroyed' do
    user = users(:john_doe)
    assert_difference 'Cart.count', -1 do
      user.destroy
    end
  end

  test 'user has many orders' do
    assert_not_empty @user.orders
  end

  test 'user orders are destroyed when user is destroyed' do
    user = users(:john_doe)
    assert_difference 'Order.count', -user.orders.count do
      user.destroy
    end
  end

  test 'user has many product reviews and rating' do
    assert_not_empty @user.product_rating_and_reviews
  end

  test 'user product reviews and ratings are destroyed when user is destroyed' do
    user = users(:john_doe)
    assert_difference 'ProductRatingAndReview.count', -user.product_rating_and_reviews.count do
      user.destroy
    end
  end

  test 'user has many add to wishlist' do
    assert_not_empty @user.add_to_wish_lists
  end

  test 'user add to wishlist destroy when user is destroyed' do
    user = users(:john_doe)
    assert_difference 'AddToWishList.count', -user.add_to_wish_lists.count do
      user.destroy
    end
  end

end
