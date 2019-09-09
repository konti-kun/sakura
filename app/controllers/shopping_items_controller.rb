class ShoppingItemsController < ApplicationController
  before_action :set_shopping_item, only: [:show, :edit, :update, :destroy]

  # GET /shopping_items
  # GET /shopping_items.json
  def index
    @shopping_items = ShoppingItem.where(user: current_user)
  end

  # GET /shopping_items/1
  # GET /shopping_items/1.json
  def show
  end

  # GET /shopping_items/new
  def new
    @shopping_item = ShoppingItem.new
  end

  # GET /shopping_items/1/edit
  def edit
  end

  # POST /shopping_items
  # POST /shopping_items.json
  def create
    @shopping_item = ShoppingItem.new(shopping_item_params)
    @shopping_item.user = current_user

    if @shopping_item.save
      redirect_to action: 'index', notice: 'カートに追加しました。'
    else
      @product = @shopping_item.product
      render template: 'products/show'
    end
  end

  # PATCH/PUT /shopping_items/1
  # PATCH/PUT /shopping_items/1.json
  def update
    respond_to do |format|
      if @shopping_item.update(shopping_item_params)
        redirect_to @shopping_item, notice: 'Shopping item was successfully updated.'
      else
        render :edit
      end
    end
  end

  # DELETE /shopping_items/1
  # DELETE /shopping_items/1.json
  def destroy
    @shopping_item.destroy
    respond_to do |format|
      format.html { redirect_to shopping_items_url, notice: 'Shopping item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_item
      @shopping_item = ShoppingItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shopping_item_params
      params.require(:shopping_item).permit(:product_id, :number)
    end
end
