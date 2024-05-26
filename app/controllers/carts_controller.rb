class CartsController < ApplicationController

  before_action :authenticate_user!, only: [:index]

  def index
    if current_user.admin?
      redirect_to root_path, alert: "Access denied."
    else
      @cart = current_user.cart if current_user
    end
  end


  def increase_quantity
    @cart = Cart.find(params[:id])
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])

    if @cart_item
      @cart_item.increment!(:quantity)
      render partial: "increase_decrease_product", locals: { cart: @cart }
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
        render partial: "increase_decrease_product", locals: { cart: @cart }
      else
        @cart_item.destroy
        if @cart.cart_items.empty?
          @cart.destroy
          redirect_to carts_path
        else
          render partial: "increase_decrease_product", locals: { cart: @cart }
        end
      end
    else
      redirect_to cart_path(@cart), alert: 'There was an error decreasing the quantity.'
    end
  end


end
