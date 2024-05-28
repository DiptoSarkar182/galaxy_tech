class ApplicationController < ActionController::Base
  before_action :set_cart
  before_action :set_components

  private

  def set_cart
    @cart = current_user.cart if user_signed_in?
  end

  def set_components
    @components = Product.pluck(:component).reject(&:blank?).uniq.sort
  end

end
