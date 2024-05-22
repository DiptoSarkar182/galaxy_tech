class CustomDeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    opts[:subject] = "Confirmation instructions (Galaxy Tech)"
    super
  end
end