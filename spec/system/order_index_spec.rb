require 'rails_helper'

RSpec.describe 'エンドユーザ向け購入履歴一覧', type: :system do
  let(:adminuser) { create :user, admin: true }
  let(:user) { create :user, admin: false }
  let(:enduser) { create :end_user, user: user, name: '桜太郎', address: '神奈川県' }
  let(:product) { create :product, name: 'サンプル1', is_displayed: true }

  scenario 'ログインしてない場合はログイン画面に遷移' do
    visit orders_path
    expect(page).to have_content 'メールアドレス'
  end

  scenario 'adminユーザの場合は商品一覧に遷移' do
    sign_in adminuser
    visit orders_path
    expect(page).to have_content '商品の一覧'
    expect(page).to have_content 'ログアウトして一般ユーザでログインしてください'
  end

  scenario '購入処理が行われているものだけを表示' do
    sign_in enduser.user
    order = create :order, :skip_validate, user: enduser.user, send_date: '2019-01-01', send_timeframe: '8 - 12', total_fee: 1000
    create :order_product, product: product, order: order
    visit orders_path
    expect(page).to have_content '1000'
    expect(page).to have_content '2019-01-01'
    expect(page).to have_content '8 - 12'
  end
end
