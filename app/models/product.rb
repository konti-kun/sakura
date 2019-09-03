class Product < ApplicationRecord
  mount_uploader :image, ImagesUploader
end
