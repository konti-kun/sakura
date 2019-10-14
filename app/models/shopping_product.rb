class ShoppingProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :user, uniqueness: { scope: %i[product user], message: 'この商品はすでにカートに追加されています。' }

  attribute :number, :integer, default: -> { 1 }
end
