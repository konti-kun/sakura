class ProductsController < ApplicationController
  before_action :set_product, only: %w[show]

  def show
    @shopping_product = ShoppingProduct.new(product: @products)
  end

  private

  def set_product
    @product = Product.published.find(params[:id])
  end
end
