require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = users(:admin)
    @test_admin = users(:test_admin)
    @user = users(:john_doe)
    @product = products(:example_product_1)
    @review = product_rating_and_reviews(:johns_product_review_1)
  end

  test "index action should get success response and paginate products" do
    get root_url
    assert_response :success
    assert_not_nil assigns(:products)
    assert_equal products.length, assigns(:products).size
  end

  test 'new action should get success response' do
    sign_in @admin_user
    get new_product_url
    assert_response :success
    assert_not_nil assigns(:product)
    assert assigns(:product).new_record?
  end

  test "create action should post product" do
    product = products(:example_product_1)

    product.key_features = ActionText::Content.new("Example feature one")
    product.specification = ActionText::Content.new("Example specification one")
    product.description = ActionText::Content.new("Example description one")

    assert_equal "Example Product one", product.name
    assert_equal 9.99, product.price
    assert_equal 10, product.quantity
    assert_equal "Example Brand one", product.brand
    assert_equal "Example feature one", product.key_features.body.to_plain_text
    assert_equal "Example specification one", product.specification.body.to_plain_text
    assert_equal "Example description one", product.description.body.to_plain_text
    assert_equal "Example component one", product.component
  end

  test 'show action should get success response' do
    show_product = products(:example_product_1)
    get product_url(show_product)
    assert_response :success
    assert_not_nil assigns(:product)
  end

  test 'edit action should get success response' do
    sign_in @admin_user
    edit_product = products(:example_product_1)
    get edit_product_url(edit_product)
    assert_response :success
    assert_not_nil assigns(:product)
    assert assigns(:product).persisted?
  end

  test "update action should update product" do
    sign_in @admin_user
    product = products(:example_product_1)
    updated_attributes = {
      name: "Updated Product Name",
      price: 19.99,
      quantity: 5,
      brand: "Updated Brand",
      key_features: "Updated feature",
      specification: "Updated specification",
      description: "Updated description",
      component: "Updated component"
    }

    patch product_url(product), params: { product: updated_attributes }

    assert_redirected_to admin_dashboards_url
    product.reload

    assert_equal "Updated Product Name", product.name
    assert_equal 19.99, product.price
    assert_equal 5, product.quantity
    assert_equal "Updated Brand", product.brand
    assert_equal "Updated feature", product.key_features.body.to_plain_text
    assert_equal "Updated specification", product.specification.body.to_plain_text
    assert_equal "Updated description", product.description.body.to_plain_text
    assert_equal "Updated component", product.component
  end

  test "destroy action should delete product and redirect" do
    sign_in @admin_user
    product = products(:example_product_1)
    assert_difference('Product.count', -1) do
      delete product_url(product)
    end

    assert_redirected_to admin_dashboards_path
  end

  test "search_product action should filter products by name, component, or brand" do
    product_one = products(:example_product_1)
    product_two = products(:example_product_2)
    get search_product_products_url, params: { product_name: "Example" }

    assert_response :success
    assert_not_nil assigns(:products)
    assert assigns(:products).include?(product_one)
    assert assigns(:products).include?(product_two)
    assert_equal products.length, assigns(:products).size
  end

  test "search_product_by_component action filters products correctly" do
    product_three = products(:example_product_3)

    get search_product_by_component_products_url, params: {
      component: product_three.component,
      start_price: "5",
      end_price: "15",
      brands: [product_three.brand],
      in_stock: 'In stock'
    }

    assert_response :success
    assert_not_nil assigns(:products)
    assert_equal 1, assigns(:products).size
    assert_equal product_three, assigns(:products).first

    expected_highest_price = Product.where(component: product_three.component).maximum(:price)
    assert_equal expected_highest_price.to_s, assigns(:highest_price).to_s

    expected_brands = Product.where(component: product_three.component).pluck(:brand).uniq
    assert_equal expected_brands.sort, assigns(:brands).sort
  end

  test 'redirect non logged in user to log in page when try to add products to cart' do
    product = products(:example_product_1)
    post add_to_cart_product_url(product)
    assert_redirected_to new_user_session_url
    assert_equal 'You must be logged in to add items to the cart.', flash[:alert]
  end

  test "creates a cart and cart item for the user if not already present" do
    new_user = User.create!(full_name:"v code", email: 'test@example.com', password: 'password', password_confirmation: 'password')
    sign_in new_user

    assert_nil new_user.cart

    post add_to_cart_product_url(@product), params: { id: @product.id }

    new_user.reload
    assert_not_nil new_user.cart

    cart_item = new_user.cart.cart_items.find_by(product: @product)
    assert_not_nil cart_item
  end

  test "increases product quantity in cart if product already exists" do
    new_user = User.create!(full_name: "v code", email: 'test@example.com', password: 'password', password_confirmation: 'password')
    sign_in new_user

    cart = new_user.create_cart

    product = products(:example_product_1)
    cart.cart_items.create!(product: product, quantity: 1)
    post add_to_cart_product_url(product), params: { id: product.id }

    new_user.reload
    cart.reload

    cart_item = cart.cart_items.find_by(product: product)

    assert_equal 2, cart_item.quantity
    assert_equal 1, cart.cart_items.count
  end

  test "should increment product quantity in cart" do
    new_user = User.create!(full_name: "Test User", email: 'test@example.com', password: 'password', password_confirmation: 'password')
    sign_in new_user

    cart = Cart.create!(user: new_user)
    product = Product.create!(name: "Test Product", price: 10.00)
    cart_item = CartItem.create!(cart: cart, product: product, quantity: 1)

    post increase_quantity_product_url(product)

    cart_item.reload
    assert_equal 2, cart_item.quantity, "Product quantity in cart should be incremented"
  end

  test "should decrement product quantity in cart" do
    new_user = User.create!(full_name: "Test User", email: 'test@example.com', password: 'password', password_confirmation: 'password')
    sign_in new_user

    cart = Cart.create!(user: new_user)
    product = Product.create!(name: "Test Product", price: 10.00)
    cart_item = CartItem.create!(cart: cart, product: product, quantity: 2)

    post decrease_quantity_product_url(product)

    cart_item.reload
    assert_equal 1, cart_item.quantity
  end

  test "should redirect non-admin user" do
    sign_in @user
    get admin_dashboards_url
    assert_redirected_to root_path
    assert_equal 'Access denied!', flash[:alert]
  end

  test "admin with specific email cannot delete product" do
    sign_in @test_admin
    new_product = Product.create!(
      name: "Example Product one",
      price: 9.99,
      quantity: 10,
      brand: "Example Brand one",
      key_features: "Example feature one",
      specification: "Example specification one",
      description: "Example description one",
      component: "Example component one"
    )

    delete product_url(new_product)

    assert_redirected_to root_path
  end


end
