class ProductsController < ApplicationController
  before_action :set_product, only: %w(show edit update destroy)
  before_action :is_admin?, only: %w(index new edit create update destroy)


  def index
    @products = Product.all.order('sort_key DESC').page(params[:page]).per(20)
  end

  def show
    @order_product = OrderProduct.new(product: @products)
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: '商品を追加しました。'
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: '商品を更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy!
    redirect_to products_url, notice: '商品を削除しました。'
  end

  private
  
    def set_product
      @product = Product.find(params[:id])
    end

  
    def product_params
      params.require(:product).permit(:name, :image, :price, :explanation, :is_displayed, :sort_key)
    end
end
