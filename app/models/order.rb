class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products
  accepts_nested_attributes_for :order_products

  validates :send_date, presence: true
  validates :send_timeframe, presence: true
  validate :check_total_fee, :check_order_products

  enum send_timeframe: {
    '8 - 12' => 0,
    '12 - 14' => 1,
    '14 - 16' => 2,
    '16 - 18' => 3,
    '18 - 20' => 4,
    '20 - 21' => 5
  }

  COD_TABLE = [
    [0,         300],
    [10_000,    400],
    [30_000,    600],
    [100_000, 1_000]
  ].freeze

  after_initialize do
    self.name = user.name
    self.address = user.address
  end

  def self.create_send_date
    send_date_range = 2.business_day.from_now.to_date..13.business_day.from_now.to_date
    send_date_range.select(&:workday?)
  end

  def calc_total_product_price
    order_products.map(&:calc_product_price).sum
  end

  def calc_cod
    total_price = calc_total_product_price
    cod = 0
    COD_TABLE.each do |price|
      break unless price[0] <= total_price

      cod = price[1]
    end
    cod
  end

  def calc_send_fee
    total_number = order_products.map(&:number).sum
    600 * (total_number / 5.0).ceil
  end

  def calc_total_fee
    total_price = calc_total_product_price
    total_price += calc_cod
    total_price += calc_send_fee
    (total_price * 1.08).floor
  end

  def check_total_fee
    return unless total_fee != calc_total_fee

    errors.add(:base, '更新処理中に金額に変更がありました。金額をお確かめの上、再度購入処理をお願いします。')
    raise ActiveRecord::RecordInvalid.new(self)
  end

  def check_order_products
    return unless OrderProduct.where(id: order_product_ids).where.not(order_id: nil).exists?

    errors.add(:base, '更新処理中に対象商品に変更がありました。内容をお確かめの上、再度購入処理をお願いします。')
    raise ActiveRecord::RecordInvalid.new(self)
  end
end
