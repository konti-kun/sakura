class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :end_user
  has_many :shopping_products, dependent: :delete_all
  has_many :orders, dependent: :delete_all
  has_many :order_products, dependent: :delete_all
  accepts_nested_attributes_for :end_user

  delegate :name, :address, to: :end_user, prefix: false
end
