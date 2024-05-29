class CartsController < ApplicationController

  before_action :authenticate_user!, only: [:index]

  def index
    if current_user.admin?
      redirect_to root_path, alert: "Access denied."
    else
      @cart = current_user.cart if current_user
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart = cart_item.cart
    cart_item.destroy

    if cart.cart_items.empty?
      cart.destroy
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("increase_decrease_product", partial: "increase_decrease_product", locals: { cart: cart }) +
          turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: current_user.cart })
      end
      format.html { redirect_to cart_path(cart) }
    end
  end


  def increase_quantity
    @cart = Cart.find(params[:id])
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])

    if @cart_item
      @cart_item.increment!(:quantity)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("increase_decrease_product", partial: "increase_decrease_product", locals: { cart: @cart }) +
            turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: current_user.cart })
        end
        format.html { redirect_to product_path(params[:product_id]) }
      end
    else
      redirect_to cart_path(@cart), alert: 'There was an error increasing the quantity.'
    end
  end

  def decrease_quantity
    @cart = Cart.find(params[:id])
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])

    if @cart_item
      if @cart_item.quantity > 1
        @cart_item.decrement!(:quantity)
      else
        @cart_item.destroy
        @cart.destroy if @cart.cart_items.empty?
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("increase_decrease_product", partial: "increase_decrease_product", locals: { cart: @cart }) +
            turbo_stream.update("cart_info", partial: "cart_items/cart_info", locals: { cart: current_user.cart })
        end
        format.html { redirect_to cart_path(@cart) }
      end
    else
      redirect_to cart_path(@cart), alert: 'There was an error decreasing the quantity.'
    end
  end


end
