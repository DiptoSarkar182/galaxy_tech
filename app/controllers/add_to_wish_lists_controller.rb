class AddToWishListsController < ApplicationController

  def index
    @wishlist_products = current_user.add_to_wish_lists.map(&:product)
  end

  def create
    @product = Product.find(params[:product_id])
    @add_to_wish_list = current_user.add_to_wish_lists.new(product: @product)
    if @add_to_wish_list.save
      render partial: "products/add_to_wishlist_button", locals: { product: @product, wishlist_item: @add_to_wish_list }
    else
      redirect_to product_path(@product), alert: 'Unable to add this product to wishlist.'
    end
  end

  def destroy
    @add_to_wish_list = current_user.add_to_wish_lists.find(params[:id])
    @product = @add_to_wish_list.product
    @add_to_wish_list.destroy
    render partial: "products/add_to_wishlist_button", locals: { product: @product, wishlist_item: nil }
  end
end
