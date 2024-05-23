class AdminDashboardsController < ApplicationController

  before_action :authenticate_admin, only: [:index]

  def index
    @products = Product.order(quantity: :desc)
  end


  private

  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end


end
