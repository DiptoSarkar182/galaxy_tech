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

      if current_user.address != params[:user][:address]
        current_user.update!(address: params[:user][:address])
      end

      # Calculate the total price of the cart
      total_price = cart.total_price
      if params[:delivery_method] == 'home_delivery'
        total_price += 60
      end

      status = params[:payment_method] == 'online_payment' ? 'pending_payment' : 'pending'
      delivery_method = params[:delivery_method] == 'home_delivery' ? 'home_delivery' : 'store_pickup'

      order = Order.create!(
        user: current_user,
        delivery_address: params[:user][:address],
        payment_method: params[:payment_method],
        total_price: total_price,
        status: status,
        delivery_method: delivery_method
      )

      cart.cart_items.each do |cart_item|
        OrderItem.create!(
          order: order,
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end

      cart.destroy
    end

    redirect_to carts_path, notice: 'Order was successfully created.'
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to create order: #{e.message}"
    render :new
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.status == 'pending' || @order.status == 'pending_payment'
      @order.destroy
      redirect_to orders_path, notice: "Order Canceled successfully!"
    else
      redirect_to orders_path, alert: "Order Canceled successfully!"
    end
  end

  def checkout
    @user = current_user
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