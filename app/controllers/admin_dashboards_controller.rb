class AdminDashboardsController < ApplicationController

  before_action :authenticate_admin

  def index

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end


  private

  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :brand, :key_features,
                                    :specification, :description)
  end

end
