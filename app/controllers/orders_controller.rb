class OrdersController < ApplicationController

  before_action :authenticate_user!

  def index
    if current_user.admin?
      redirect_to root_path, alert: 'Access denied!'
    else
      @orders = current_user.orders.order(created_at: :desc)
    end
  end

  def create
    ActiveRecord::Base.transaction do
      cart = Cart.find_by(user_id: current_user.id)

      # Calculate the total price of the cart
      total_price = cart.total_price

      order = Order.create!(
        user: current_user,
        # delivery_address: params[:delivery_address],
        # payment_method: params[:payment_method],
        total_price: total_price,
        status: 'pending'
      )

      cart.cart_items.each do |cart_item|
        OrderItem.create!(
          order: order,
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end

      # cart.cart_items.destroy_all
      cart.destroy
    end

    redirect_to carts_path, notice: 'Order was successfully created.'
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to create order: #{e.message}"
    render :new
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.status == 'pending'
      @order.destroy
      redirect_to orders_path, notice: "Order Canceled successfully!"
    else
      redirect_to orders_path, alert: "Order Canceled successfully!"
    end
  end

  def checkout
    if current_user.admin?
      redirect_to root_path, alert: "Access denied."
    else
      @cart = current_user.cart if current_user
      if @cart.nil?
        redirect_to carts_path, alert: "Your cart is empty. Please add some products before proceeding to payment."
      end
    end
  end

end