class CallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    begin
      @user, is_new_user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in_and_redirect @user
      if is_new_user
        set_flash_message(:notice, :signed_up) if is_navigational_format?
      else
        set_flash_message(:notice, :signed_in) if is_navigational_format?
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = "There was a problem signing in through Google. Please register or try again."
      redirect_to new_user_registration_url
    end
  end
end