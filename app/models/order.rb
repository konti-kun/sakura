class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products

  validates :send_date, presence: true
  validates :send_timeframe, presence: true

  enum send_timeframes: {
    '8 - 12' => 0,
    '12 - 14' => 1,
    '14 - 16' => 2,
    '16 - 18' => 3,
    '18 - 20' => 4,
    '20 - 21' => 5,
  }

  COD_TABLE = [
    [0,      300],
    [10000,  400],
    [30000,  600],
    [100000, 1000],
  ]

  def self.create_send_date
    send_date_range = 2.business_day.from_now.to_date .. 13.business_day.from_now.to_date
    send_date_range.select {|item| item.workday? }
  end

  def calc_total_product_price
    user.cart.includes(:product).map{ |op| op.calc_product_price}.sum
  end

  def calc_cod
    total_price = calc_total_product_price
    cod = 0
    COD_TABLE.each{|price|
      if price[0] <= total_price
        cod = price[1]
      else
        break
      end
    }
    cod
  end

  def calc_send_fee
    total_number = user.cart.map{ |op| op.number }.sum
    600 * (total_number/5.0).ceil
  end

  def calc_total_price
    total_price = calc_total_product_price
    total_price += calc_cod
    total_price += calc_send_fee
    (total_price * 1.08).floor
  end

end
