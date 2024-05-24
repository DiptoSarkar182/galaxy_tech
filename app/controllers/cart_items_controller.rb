class CartItemsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.new(product: @product, quantity: 1)

    if @cart_item.save
      redirect_to product_path(@product), notice: 'Product was successfully added to cart.'
    else
      redirect_to product_path(@product), alert: 'There was an error adding the product to the cart.'
    end
  end

  def increase_quantity
    @cart_item = CartItem.find_by(cart: current_user.cart, product_id: params[:product_id])

    if @cart_item
      @cart_item.increment!(:quantity)
      redirect_to product_path(params[:product_id]), notice: 'Quantity was successfully increased.'
    else
      redirect_to product_path(params[:product_id]), alert: 'There was an error increasing the quantity.'
    end
  end

  def decrease_quantity
    @cart_item = CartItem.find_by(cart: current_user.cart, product_id: params[:product_id])

    if @cart_item
      if @cart_item.quantity > 1
        @cart_item.decrement!(:quantity)
        redirect_to product_path(params[:product_id]), notice: 'Quantity was successfully decreased.'
      else
        @cart = @cart_item.cart
        @cart_item.destroy
        @cart.destroy if @cart.cart_items.empty?
        redirect_to product_path(params[:product_id]), notice: 'Product was successfully removed from cart.'
      end
    else
      redirect_to product_path(params[:product_id]), alert: 'There was an error decreasing the quantity.'
    end
  end

end
