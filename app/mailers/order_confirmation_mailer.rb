class OrderConfirmationMailer < ApplicationMailer
  default from: 'diptosarkarhridoy@gmail.com'

  def order_confirmation(user, order, order_item_ids)
    @user = user
    @order = order
    @order_items = OrderItem.includes(:product).find(order_item_ids)
    mail(to: @user.email, subject: "Your Galaxy Tech Order #{@order.order_number}")
  end
end
