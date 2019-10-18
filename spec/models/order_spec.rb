require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create :user, admin: false }
  let(:enduser) { create :end_user, user: user, name: '桜太郎', address: '神奈川県' }
  let(:product1) { create :product, name: 'サンプル１', price: 10 }
  let(:product2) { create :product, name: 'サンプル２', price: 2 }

  context '総額の計算' do
    it '10円1個の時10円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 1)
      expect(order.calc_total_product_price).to eq 10
    end

    it '10円2個の時20円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 2)
      expect(order.calc_total_product_price).to eq 20
    end
    it '10円1個,2円２個の時14円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 1)
      order.order_products << build(:order_product, product: product2, number: 2)
      expect(order.calc_total_product_price).to eq 14
    end
  end

  context '代引き手数料の計算' do
    it '10000円以下の場合, 300円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 1)
      expect(order.calc_cod).to eq 300
    end
    it '10000円の場合, 400円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 1000)
      expect(order.calc_cod).to eq 400
    end
    it '10010円の場合, 400円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 1001)
      expect(order.calc_cod).to eq 400
    end
    it '30000円の場合, 600円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 3000)
      expect(order.calc_cod).to eq 600
    end
    it '30010円の場合, 600円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 3001)
      expect(order.calc_cod).to eq 600
    end
    it '100000円の場合, 1000円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 10_000)
      expect(order.calc_cod).to eq 1000
    end
    it '100000円以上の場合, 1000円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 11_000)
      expect(order.calc_cod).to eq 1000
    end
  end

  context '送料の計算' do
    it '1商品1個の場合, 600円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 1)
      expect(order.calc_send_fee).to eq 600
    end
    it '1商品5個の場合, 600円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 5)
      expect(order.calc_send_fee).to eq 600
    end
    it '1商品6個の場合、1200円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 6)
      expect(order.calc_send_fee).to eq 1200
    end
    it '2商品5個の場合、600円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 2)
      order.order_products << build(:order_product, product: product2, number: 3)
      expect(order.calc_send_fee).to eq 600
    end
    it '2商品6個の場合、1200円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 3)
      order.order_products << build(:order_product, product: product2, number: 3)
      expect(order.calc_send_fee).to eq 1200
    end
    it '1商品11個の場合, 1800円' do
      order = build :order, user: enduser.user
      order.order_products << build(:order_product, product: product1, number: 11)
      expect(order.calc_send_fee).to eq 1800
    end
  end
end
