class WelcomeUserMailer < ApplicationMailer
  default from: 'diptosarkarhridoy@gmail.com'

  def welcome_email
    @user = params[:user]
    @url  = 'https://galaxy-tech.onrender.com/'
    mail(to: @user.email, subject: 'Welcome to Galaxy Tech')
  end
end
