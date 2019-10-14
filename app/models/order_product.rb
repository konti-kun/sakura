class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  attribute :number, :integer, default: -> { 1 }

  def calc_product_price
    product.price * number
  end
end
