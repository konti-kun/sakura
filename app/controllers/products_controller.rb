class ProductsController < ApplicationController
  before_action :set_product, only: %w(show edit update destroy)
  before_action :is_admin?, only: %w(index new edit create update destroy)

  class PermissionError < ActionController::ActionControllerError; end

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

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def is_admin?
      if not current_user&.is_admin?
        raise PermissionError
      end
    end
  
    def set_product
      @product = Product.find(params[:id])
    end

  
    def product_params
      params.require(:product).permit(:name, :image, :price, :explanation, :is_displayed, :sort_key)
    end
end
