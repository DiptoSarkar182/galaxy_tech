class CartItemsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :increase_quantity, :decrease_quantity]

  def create
    @product = Product.find(params[:product_id])
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.new(product: @product, quantity: 1)

    if @cart_item.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("add_to_cart_increase_decrease_quantity", partial: "products/add_to_cart_increase_decrease_quantity", locals: { product: @product }) +
            turbo_stream.update("cart_info", partial: "cart_info", locals: { cart: @cart })
        end
        format.html { redirect_to product_path(@product) }
      end
    else
      redirect_to product_path(@product), alert: 'There was an error adding the product to the cart.'
    end
  end

  def increase_quantity
    @cart_item = CartItem.find_by(cart: current_user.cart, product_id: params[:product_id])

    if @cart_item
      @cart_item.increment!(:quantity)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("add_to_cart_increase_decrease_quantity", partial: "products/add_to_cart_increase_decrease_quantity", locals: { product: @cart_item.product }) +
            turbo_stream.update("cart_info", partial: "cart_info", locals: { cart: current_user.cart })
        end
        format.html { redirect_to product_path(params[:product_id]) }
      end
    else
      redirect_to product_path(params[:product_id]), alert: 'There was an error increasing the quantity.'
    end
  end

  def decrease_quantity
    @cart_item = CartItem.find_by(cart: current_user.cart, product_id: params[:product_id])

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
          render turbo_stream: turbo_stream.update("add_to_cart_increase_decrease_quantity", partial: "products/add_to_cart_increase_decrease_quantity", locals: { product: @cart_item.product }) +
            turbo_stream.update("cart_info", partial: "cart_info", locals: { cart: current_user.cart })
        end
        format.html { redirect_to product_path(params[:product_id]) }
      end
    else
      redirect_to product_path(params[:product_id]), alert: 'There was an error decreasing the quantity.'
    end
  end

end
