class RegistrationsController < Devise::RegistrationsController

  def create
    super do |user|
      if user.persisted?
        WelcomeUserMailer.with(user: @user).welcome_email.deliver_later
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email,
                                 :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:full_name, :email,
                                 :password, :password_confirmation,
                                 :current_password, :address)
  end

end