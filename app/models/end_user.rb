class EndUser < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImagesUploader

  validates :name, presence: true
  validates :address, presence: true
end
