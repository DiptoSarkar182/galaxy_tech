class DeviseConfirmationJob < ApplicationJob
  queue_as :default

  def perform(user, token, opts)
    # Directly invoke Devise::Mailer to send the confirmation instructions
    Devise::Mailer.confirmation_instructions(user, token, opts).deliver_now
  end
end