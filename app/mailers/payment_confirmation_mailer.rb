class PaymentConfirmationMailer < ApplicationMailer

  def payment_confirmation_email(user, order)
    @user = user
    @order = order

    # Fetch the charge from Stripe
    stripe_charge = Stripe::Charge.retrieve(@order.stripe_charge_id)

    # Include the charge data in the email
    @charge_data = {
      amount_paid: stripe_charge.amount / 100.0, # Stripe amounts are in cents
      charge_id: stripe_charge.id
    }

    mail(to: @user.email, subject: "Your Galaxy Tech Payment Confirmation #{@order.order_number}")
  end
end
