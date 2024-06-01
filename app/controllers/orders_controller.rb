class OrdersController < ApplicationController

  before_action :authenticate_user!

  def index
    if current_user.admin?
      redirect_to root_path, alert: 'Access denied!'
    else
      @orders = current_user.orders.order(created_at: :desc)
    end
  end

  # def create
  #   ActiveRecord::Base.transaction do
  #     cart = Cart.find_by(user_id: current_user.id)
  #
  #     if current_user.address != params[:user][:address]
  #       current_user.update!(address: params[:user][:address])
  #     end
  #
  #     # Calculate the total price of the cart
  #     total_price = cart.total_price
  #     if params[:delivery_method] == 'home_delivery'
  #       total_price += 60
  #     end
  #
  #     status = params[:payment_method] == 'online_payment' ? 'pending_payment' : 'processing'
  #     delivery_method = params[:delivery_method] == 'home_delivery' ? 'home_delivery' : 'store_pickup'
  #
  #     order = Order.create!(
  #       user: current_user,
  #       delivery_address: params[:user][:address],
  #       payment_method: params[:payment_method],
  #       total_price: total_price,
  #       status: status,
  #       delivery_method: delivery_method
  #     )
  #
  #     cart.cart_items.each do |cart_item|
  #       OrderItem.create!(
  #         order: order,
  #         product: cart_item.product,
  #         quantity: cart_item.quantity,
  #         price: cart_item.product.price
  #       )
  #     end
  #
  #     cart.destroy
  #   end
  #
  #   if params[:payment_method] == 'online_payment'
  #     redirect_to stripe_payment_orders_path, notice: 'Your order is awaiting payment confirmation.'
  #   else
  #     redirect_to carts_path, notice: 'Order was successfully created.'
  #   end
  # rescue ActiveRecord::RecordInvalid => e
  #   flash[:error] = "Failed to create order: #{e.message}"
  #   render :new
  # end

  def create
    order = nil

    ActiveRecord::Base.transaction do
      cart = Cart.find_by(user_id: current_user.id)

      if current_user.address != params[:user][:address]
        current_user.update!(address: params[:user][:address])
      end

      # Calculate the total price of the cart
      total_price = cart.total_price
      if params[:delivery_method] == 'home_delivery'
        total_price += 10
      end

      status = params[:payment_method] == 'online_payment' ? 'pending_payment' : 'processing'
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

    if params[:payment_method] == 'online_payment'
      redirect_to stripe_payment_order_path(order), notice: 'Your order is awaiting payment confirmation.'
    else
      redirect_to carts_path, notice: 'Order was successfully created.'
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to create order: #{e.message}"
    render :new
  end

  def show
    begin
      @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to orders_path # or wherever you want to redirect
    end
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.status == 'processing' || @order.payment_method == 'cash_on_delivery'
      @order.destroy
      redirect_to orders_path, notice: "Order Canceled successfully!"
    elsif @order.payment_method == 'online_payment' &&  @order.is_payment_completed == false
      @order.destroy
      redirect_to orders_path, notice: "Order Canceled successfully!"
    else
      redirect_to orders_path, alert: "Order cannot be cancelled at this time."
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

  # def stripe_payment
  #   # Fetch the latest order of the current user
  #   @order = current_user.orders.order(created_at: :desc).first
  #
  #   # If there's no order or the order is not pending payment, redirect the user
  #   if @order.nil? || @order.status != 'pending_payment'
  #     redirect_to root_path, alert: 'No pending payment found.'
  #     return
  #   end
  #
  #   # Fetch the total price of the order
  #   @total_price = @order.total_price
  # end

  def stripe_payment
    @order = Order.find(params[:id])
    if @order.user != current_user
      redirect_to root_path, alert: 'You are not authorized to view this page.'
      return
    end

    if @order.status != 'pending_payment' || @order.is_payment_completed
      redirect_to root_path, alert: 'No pending payment found.'
      return
    end

    @total_price = @order.total_price
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Order not found.'
  end


  def submit_stripe_payment
    # card decline test 4000000000000341
    @order = Order.find(params[:order_id])

    if @order.user != current_user
      redirect_to root_path, alert: 'You are not authorized to view this page.'
      return
    end

    if @order.status != 'pending_payment' || @order.is_payment_completed
      redirect_to root_path, alert: 'No pending payment found.'
      return
    end

    @total_price_usd = @order.total_price
    @total_price_usd_cents = (@total_price_usd.to_f * 100).round
    token = params[:stripeToken]

    ActiveRecord::Base.transaction do
      customer = Stripe::Customer.create(
        email: current_user.email,
        source: token
      )

      Stripe::Charge.create(
        customer: customer.id,
        amount: @total_price_usd_cents,
        description: 'Your Order',
        currency: 'usd'
      )

      # Update the order status and is_payment_completed attribute
      @order.update!(status: 'processing', is_payment_completed: true)
    end

    render plain: 'success'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Order not found.'
  rescue Stripe::CardError => e
    render plain: e.message, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render plain: e.message, status: :unprocessable_entity
  end

end