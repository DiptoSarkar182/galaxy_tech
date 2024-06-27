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

end
