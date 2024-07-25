class CustomDeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    # Use Active Job to send the email after a 15-second delay
    DeviseConfirmationJob.set(wait: 15.seconds).perform_later(record, token, opts)
  end
end
