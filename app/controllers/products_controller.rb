class ProductsController < ApplicationController

  before_action :authenticate_admin, only: [:new, :edit, :create, :update]
  def index
    @products = Product.page(params[:page]).per(18)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html {redirect_to admin_dashboards_path, notice: "Product created successfully"}
      else
        format.html {render 'new', status: :unprocessable_entity}
      end
    end
  end

  def show
    @product = Product.find(params[:id])
    @cart = current_user.cart if user_signed_in?
    @title = @product.name
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        format.html {redirect_to admin_dashboards_path, notice: "Product updated successfully!"}
      else
        format.html {render 'edit', status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_dashboards_path, notice: "Product deleted successfully!"
  end

  def search_product
    @q = Product.ransack(name_cont: params[:product_name])
    @products = @q.result(distinct: true).page(params[:page]).per(5)
  end


  def search_product_by_component
    start_price = params[:start_price] ? params[:start_price].gsub(',', '').to_d : 0
    end_price = params[:end_price] ? params[:end_price].gsub(',', '').to_d : Float::INFINITY

    query = { component_eq: params[:component] }
    if start_price != 0 || end_price != 0
      query[:price_gteq] = start_price
      query[:price_lteq] = end_price
    end
    query[:brand_in] = params[:brands] if params[:brands].present?
    query[:quantity_gt] = 0 if params[:in_stock] == 'In stock'

    @q = Product.ransack(query)
    @products = @q.result.page(params[:page]).per(5)
    @highest_price = Product.where(component: params[:component]).maximum(:price)
    @brands = Product.where(component: params[:component]).pluck(:brand).uniq
  end

  def add_to_cart
    if current_user.nil?
      redirect_to new_user_session_path, alert: 'You must be logged in to add items to the cart.'
      return
    end
    @product = Product.find(params[:id])
    @cart = current_user.cart || current_user.create_cart

    @cart_item = @cart.cart_items.find_by(product: @product)

    if @cart_item
      @cart_item.increment!(:quantity)
    else
      @cart_item = @cart.cart_items.new(product: @product, quantity: 1)
    end

    if @cart_item.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("search_product_by_component_add_inc_dec_#{@product.id}", partial: "search_product_by_component_add_inc_dec", locals: { product: @product }) +
            turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: @cart })
        end
        format.html { redirect_to search_product_by_component_products_path }
      end
    else
      redirect_to product_path(@product), alert: 'There was an error adding the product to the cart.'
    end
  end

  def increase_quantity
    @product = Product.find(params[:id])
    @cart_item = CartItem.find_by(cart: current_user.cart, product_id: params[:id])

    if @cart_item
      @cart_item.increment!(:quantity)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("search_product_by_component_add_inc_dec_#{@product.id}", partial: "search_product_by_component_add_inc_dec", locals: { product: @product }) +
            turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: @cart })
        end
        # format.html { redirect_to product_path(params[:product_id]) }
      end
    else
      redirect_to product_path(params[:product_id]), alert: 'There was an error increasing the quantity.'
    end
  end

  def decrease_quantity
    @product = Product.find(params[:id])
    @cart_item = CartItem.find_by(cart: current_user.cart, product_id: params[:id])

    if @cart_item
      if @cart_item.quantity > 1
        @cart_item.decrement!(:quantity)
      else
        @cart = @cart_item.cart
        @cart_item.destroy
        @cart.destroy if @cart.cart_items.empty?
      end
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("search_product_by_component_add_inc_dec_#{@product.id}", partial: "search_product_by_component_add_inc_dec", locals: { product: @product }) +
            turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: @cart })
        end
        # format.html { redirect_to product_path(params[:product_id]) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("search_product_by_component_add_inc_dec_#{@product.id}", partial: "search_product_by_component_add_inc_dec", locals: { product: @product }) +
            turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: @cart })
        end
        # redirect_to product_path(params[:id]), alert: 'There was an error decreasing the quantity.'
        format.html { redirect_to product_path(params[:id]), alert: 'There was an error decreasing the quantity.' }
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :brand, :key_features,
                                    :specification, :description, :product_image, :component)
  end

  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end

end
