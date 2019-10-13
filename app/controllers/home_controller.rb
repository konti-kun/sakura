class HomeController < ApplicationController
  def index
    @products = Product.published.page(params[:page]).per(50)
  end
end
