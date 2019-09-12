class OrderProductsController < ApplicationController
  before_action :set_order_product, only: [:show, :edit, :update, :destroy]

  def index
    @order_products = current_user.order_products
  end

  def show
  end

  def new
    @order_product = OrderProduct.new
  end

  def edit
  end

  def create
    @order_product = OrderProduct.new(order_product_params)
    @order_product.user = current_user

    if @order_product.save
      redirect_to action: 'index', notice: 'カートに追加しました。'
    else
      @product = @order_product.product
      render template: 'products/show'
    end
  end

  def update
    if @order_product.update(order_product_params)
      redirect_to action: 'index', notice: 'カートを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @order_product.destroy
    redirect_to action: 'index', notice: '商品を削除しました。'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_product
      @order_product = current_user.order_products.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_product_params
      params.require(:order_product).permit(:product_id, :number)
    end
end
