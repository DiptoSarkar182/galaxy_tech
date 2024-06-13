class ProductRatingsAndReviewsController < ApplicationController

  def new
    @order = Order.find_by(id: params[:order_id])
    @product = Product.find_by(id: params[:product_id])

    if @order.nil? || @product.nil?
      redirect_to orders_path, alert: 'Invalid order or product.'
    elsif ProductRatingAndReview.exists?(order: @order, product: @product, user: current_user)
      redirect_to orders_path, alert: 'You have already rated this product for this order.'
    else
      @product_rating_and_review = ProductRatingAndReview.new(order: @order, product: @product)
    end
  end

  def create
    @order = Order.find(params[:product_rating_and_review][:order_id])
    @product = Product.find(params[:product_rating_and_review][:product_id])
    @product_rating_and_review = ProductRatingAndReview.new(product_rating_and_review_params)
    @product_rating_and_review.user_id = current_user.id

    if @product_rating_and_review.save
      redirect_to order_path(@order), notice: 'Review was successfully created.'
    else
      render :new
    end
  end


  private

  def product_rating_and_review_params
    params.require(:product_rating_and_review).permit(:rating, :order_id, :product_id)
  end

end
