class AdminDashboardsController < ApplicationController
  before_action :authenticate_admin

  def index
    @total_sales_over_time = Order.where(status: 'delivered').group_by_day(:updated_at).sum('total_price')
    @top_selling_products = OrderItem.joins(:product, :order)
                                     .where(orders: { status: 'delivered' })
                                     .group('products.name')
                                     .sum('quantity')
    @sales_by_payment_method = Order.where(status: 'delivered').group(:payment_method).sum('total_price')
    @total_users = User.count
    @confirmed_users = User.where.not(confirmed_at: nil).count
    @unconfirmed_users = User.where(confirmed_at: nil).count
    @admin_users = User.where(is_admin: true).count
    @products_by_component = Product.group(:component).sum(:quantity)
  end

  def show
    @pending_order = Order.includes(:user, order_items: :product).find(params[:id])
  end


  def pending_orders
    @pending_orders = Order.includes(:user, order_items: :product)
                           .where(status: ['processing', 'shipped', 'delivered'])
                           .page(params[:page]).per(10)
  end

  def change_customer_order_status
    @pending_order = Order.find(params[:id])
    old_status = @pending_order.status
    @pending_order.status = params[:order][:status].downcase

    respond_to do |format|
      if @pending_order.save
        if old_status != 'delivered' && @pending_order.status == 'delivered'
          @pending_order.order_items.each do |item|
            item.product.decrement!(:quantity, item.quantity)
          end
        end
        format.html { redirect_to admin_dashboard_path, notice: "Pending order status updated successfully!" }
      else
        format.html { render admin_dashboard_path, status: :unprocessable_entity }
      end
    end
  end

  def all_products
    @q = Product.ransack(params[:q])
    @products = @q.result.page(params[:page]).per(10)
  end

  def download_order
    order = Order.find(params[:id])

    pdf = Prawn::Document.new do
      # User and Order Details
      text "Order Details", size: 20, style: :bold
      move_down 10
      text "Customer Name: #{order.user.full_name}"
      text "Delivery Address: #{order.delivery_address}"
      text "Order Number: #{order.order_number}"
      text "Order Date: #{order.created_at.strftime('%B %d, %Y %I:%M %p')}"
      if order.payment_method == "cash_on_delivery"
        text "Payment Method: Cash On Delivery"
      elsif order.payment_method == "online_payment"
        text "Payment Method: Online Payment Via Stripe"
        text "Stripe Charge ID: #{order.stripe_charge_id}"
      end

      if order.delivery_method == "home_delivery"
        text "Delivery Method: Home Delivery"
      elsif order.delivery_method == "store_pickup"
        text "Delivery Method: Store Pickup"
      end
      move_down 20

      # Table for Order Items
      items_data = [["Serial", "Product Name", "Price", "Quantity", "Total Price"]]
      order.order_items.each_with_index do |item, index|
        items_data << [
          index + 1,
          item.product.name,
          "$#{item.price}",
          item.quantity,
          "$#{item.price * item.quantity}"
        ]
      end
      table(items_data, header: true, position: :center, column_widths: [50, 150, 100, 100, 100], cell_style: { align: :center })

      # Total Price
      sub_total_price = order.order_items.sum { |item| item.price * item.quantity }
      if order.delivery_method == "home_delivery"
        move_down 10
        text "Sub Total: $#{sub_total_price}", style: :bold, align: :right
        text "Delivery Charge: $10", style: :bold, align: :right
        if order.payment_method == "online_payment" && order.is_payment_completed
          text "Amount Paid: $#{order.total_price}", style: :bold, align: :right
        else
          text "Cash To Pay: $#{order.total_price}", style: :bold, align: :right
        end
      elsif order.delivery_method == "store_pickup"
        move_down 10
        text "Sub Total: $#{sub_total_price}", style: :bold, align: :right
        text "Delivery Charge: $0", style: :bold, align: :right
        if order.payment_method == "online_payment" && order.is_payment_completed
          text "Amount Paid: $#{order.total_price}", style: :bold, align: :right
        else
          text "Cash To Pay: $#{order.total_price}", style: :bold, align: :right
        end
      end
      move_down 20
      text "Thank you for ordering from Galaxy Tech. If you have any complaints about this order, please call us at 123-456-789 or email us at support@galaxytech.com."
      text "This is a system generated invoice and no signature or seal is required."
    end


    pdf.number_pages "Page <page> of <total>", { start_count_at: 1, at: [pdf.bounds.right - 100, 0], align: :right, size: 8 }
    send_data pdf.render, filename: "order_#{order.order_number}.pdf", type: 'application/pdf', disposition: 'attachment'
  end

  private

  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end


end
