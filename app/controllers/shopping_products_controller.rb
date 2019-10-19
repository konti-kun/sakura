class ShoppingProductsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :set_shopping_product, only: %w[destroy]

  def index
    @shopping_products = current_user.shopping_products
  end

  def create
    new_or_update_shopping_product(shopping_product_params.to_h.symbolize_keys)

    if @shopping_product.save
      redirect_to ({ action: 'index' }), notice: @message
    else
      @product = @shopping_product.product
      render 'products/show'
    end
  end

  def destroy
    @shopping_product.destroy!
    redirect_to ({ action: 'index' }), notice: '商品を削除しました。'
  end

  private

  def set_shopping_product
    @shopping_product = current_user.shopping_products.find(params[:id])
  end

  def new_or_update_shopping_product(product_id:, number:)
    @shopping_product = current_user.shopping_products.find_or_initialize_by(product_id: product_id) do |sp|
      sp.number = number.to_i
    end

    if @shopping_product.new_record?
      @message = 'カートに追加しました'
    else
      @message = "登録されている商品に#{number}個、追加しました"
      @shopping_product.number += number.to_i
    end
  end

  def shopping_product_params
    params.require(:shopping_product).permit(:product_id, :number)
  end
end
