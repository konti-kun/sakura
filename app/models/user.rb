class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :end_user
  has_many :cart, -> {where(order_id: nil)}, class_name: 'OrderProduct'
  has_many :orders
  accepts_nested_attributes_for :end_user
end
