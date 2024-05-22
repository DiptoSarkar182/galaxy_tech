class AdminDashboardsController < ApplicationController

  before_action :authenticate_admin
  def index

  end

  private
  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end
end
