class OrderProductsController < ApplicationController
  before_action :set_order_product, only: %w[destroy]
  before_action :end_user?, only: %w[index create]

  def index
    @order_products = current_user.cart
  end

  def create
    @order_product = current_user.order_products.new(order_product_params)

    if @order_product.save
      redirect_to action: 'index', notice: 'カートに追加しました。'
    else
      @product = @order_product.product
      render template: 'products/show'
    end
  end

  def destroy
    @order_product.destroy!
    redirect_to action: 'index', notice: '商品を削除しました。'
  end

  private

  def set_order_product
    @order_product = current_user.cart.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_product_params
    params.require(:order_product).permit(:product_id, :number)
  end
end
