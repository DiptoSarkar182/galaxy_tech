class ApplicationController < ActionController::Base
  before_action :set_cart

  private

  def set_cart
    @cart = current_user.cart if user_signed_in?
  end

end
