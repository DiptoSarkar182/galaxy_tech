class RegistrationsController < Devise::RegistrationsController

  def create
    super do |user|
      if user.persisted?
        WelcomeUserMailer.with(user: @user).welcome_email.deliver_later
      end
    end
  end

  protected

  def update_resource(resource, params)
    if resource.provider == 'google_oauth2'
      params.delete(:current_password)
      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation)
      end
      resource.update_without_password(params)
    else
      super
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:full_name, :email,
                                 :password, :password_confirmation)
  end

  def account_update_params
    permitted_params = [:full_name, :password, :password_confirmation, :current_password, :address]
    permitted_params << :email unless current_user.provider == 'google_oauth2'
    params.require(:user).permit(permitted_params)
  end

end