class Product < ApplicationRecord
  mount_uploader :image, ImagesUploader

  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :image, presence: true
  validates :sort_key, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :published, -> { where(is_displayed: true).order(sort_key: 'DESC') }
end
