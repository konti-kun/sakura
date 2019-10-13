require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create :user, admin: false }
  let(:enduser) { create :end_user, user: user, name: '桜太郎', address: '神奈川県' }
  let(:order) { build :order, user: enduser.user }
  let(:product1) { create :product, name: 'サンプル１', price: 10 }
  let(:product2) { create :product, name: 'サンプル２', price: 20 }

  context '総額の計算' do
    it '10円１個の時10円' do
    end
  end
end
