class OrderProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :order, optional: true

  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user, uniqueness: { scope: %i[product order], message: 'この商品はすでにカートに追加されています。' }

  attribute :number, :integer, default: -> { 1 }

  def calc_product_price
    product.price * number
  end
end
