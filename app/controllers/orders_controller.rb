class OrdersController < ApplicationController
  before_action :is_end_user?, only: %w[index new create]

  def index
    @orders = current_user.orders.order('created_at DESC').page(params[:page]).per(20)
  end

  def new
    if not current_user.cart.exists?
      flash[:danger] = '商品を選択してください。'
      redirect_to controller: 'home', action: 'index'
    end
    @order = current_user.orders.new
    @order.order_products = current_user.cart
  end

  def create
    Order.transaction do
      @order = current_user.orders.new(order_params)
      @order.order_product_ids = order_products_params['order_products']
      @order.save!
      flash[:notice] = '購入処理が完了しました。'
      redirect_to controller: 'home', action: 'index'
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private
    def order_params
      params.require(:order).permit(:name, :address, :send_date, :send_timeframe, :total_fee)
    end
    
    def order_products_params
      params.require(:order).permit(order_products: [])
    end
end
