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

  private

  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end


end
