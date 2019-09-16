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
    end_user = current_user.end_user
    @order = Order.new(user: current_user, name: end_user.name, address: end_user.address)
  end

  def create
    Order.transaction do
      @order = Order.new(order_params)
      @order.user = current_user
      @order.save!
      ids = params['order']['order_products'].map{|id| id.to_i}
      OrderProduct.where(id: ids).update_all(order_id: @order.id)
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
end
