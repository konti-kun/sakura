require 'rails_helper'

RSpec.describe 'エンドユーザ向け購入履歴一覧', type: :system do
  let(:adminuser){create :user, is_admin: true}
  let(:user){create :user, is_admin: false }
  let(:enduser){create :end_user, user: user, name: '桜太郎', address: '神奈川県' }
  let(:product){create :product, name: 'サンプル1', is_displayed: true}

  scenario "ログインしてない場合はログイン画面に遷移" do
    visit orders_path
    expect(page).to have_content 'メールアドレス'
  end

  scenario "adminユーザの場合は商品一覧に遷移" do
    sign_in adminuser
    visit orders_path
    expect(page).to have_content '商品の一覧'
    expect(page).to have_content 'ログアウトして一般ユーザでログインしてください'
  end

  scenario "購入処理が行われているものだけを表示" do
    order = create :order, user: user, send_date: '2019-01-01', send_timeframe: '8 - 12', total_fee: 1000
    create :order_product, product: product, user: user, order: order
    sign_in enduser.user
    visit orders_path
    expect(page).to have_content '1000'
    expect(page).to have_content '2019-01-01'
    expect(page).to have_content '8 - 12'
  end
end


