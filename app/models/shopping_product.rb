class ShoppingProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  attribute :number, :integer, default: -> { 1 }
end
