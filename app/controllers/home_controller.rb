class HomeController < ApplicationController
  def index
    @products = Product.all.order('sort_key DESC').page(params[:page]).per(50)
  end
end
