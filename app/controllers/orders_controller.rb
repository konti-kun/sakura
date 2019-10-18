class OrdersController < ApplicationController
  before_action :authenticate_end_user!, only: %w[index new create]

  def index
    @orders = current_user.orders.order('created_at DESC').page(params[:page]).per(20)
  end

  def new
    unless current_user.shopping_products.exists?
      flash[:danger] = '商品を選択してください。'
      redirect_to controller: 'home', action: 'index'
    end
    @order = current_user.orders.new(order_products_attributes: create_order_products)
  end

  def create
    Order.transaction do
      @order = current_user.orders.build(order_params)
      @order.save!
      current_user.shopping_products.delete_all
      flash[:notice] = '購入処理が完了しました。'
      redirect_to controller: 'home', action: 'index'
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def create_order_products
    current_user.shopping_products.map do |shopping_product|
      shopping_product.slice('product_id', 'number')
    end
  end

  def order_params
    params.require(:order).permit(:name, :address, :send_date, :send_timeframe, :total_fee, order_products_attributes: %i[product_id number])
  end
end
