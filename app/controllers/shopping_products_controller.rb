class ShoppingProductsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :set_shopping_product, only: %w[destroy]

  def index
    @shopping_products = current_user.shopping_products
  end

  def create
    @shopping_product = current_user.shopping_products.build(shopping_product_params)

    if @shopping_product.save
      redirect_to action: 'index', notice: 'カートに追加しました。'
    else
      @product = @shopping_product.product
      render 'products/show'
    end
  end

  def destroy
    @shopping_product.destroy!
    redirect_to action: 'index', notice: '商品を削除しました。'
  end

  private

  def set_shopping_product
    @shopping_product = current_user.shopping_products.find(params[:id])
  end

  def shopping_product_params
    params.require(:shopping_product).permit(:product_id, :number)
  end
end
