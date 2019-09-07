class HomeController < ApplicationController
  def index
    @products = Product.where(is_displayed: true).order('sort_key DESC').page(params[:page]).per(50)
  end
end
