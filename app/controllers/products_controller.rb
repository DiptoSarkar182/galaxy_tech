class ProductsController < ApplicationController

  before_action :authenticate_admin, only: [:edit, :create, :update]
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html {redirect_to admin_dashboards_path, notice: "Product created successfully"}
      else
        format.html {render 'new', status: :unprocessable_entity}
      end
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        format.html {redirect_to admin_dashboards_path, notice: "Product updated successfully!"}
      else
        format.html {render 'edit', status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_dashboards_path, notice: "Product deleted successfully!"
  end

  private

  def product_params
    params.require(:product).permit(:name, :price, :quantity, :brand, :key_features,
                                    :specification, :description, :product_image)
  end

  def authenticate_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied!'
    end
  end

end
