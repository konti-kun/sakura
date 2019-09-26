require 'rails_helper'

RSpec.describe '商品の登録', type: :system do
  let(:adminuser){create :user, admin: true}
  let(:enduser){create :user, admin: false}

  scenario "adminユーザでログインすると商品の登録メニューがありクリックすると画面遷移する" do
    sign_in adminuser
    visit root_path
    click_link '商品の登録'
    expect(page).to have_content '商品の登録'
  end

  scenario "enduserでログインしても商品の登録ボタンが存在しない" do
    sign_in enduser
    visit root_path
    expect(page).to have_no_link '商品の登録' 
  end

  scenario "enduserでは商品追加はできない" do
    sign_in enduser
    visit new_product_path
    expect(page).to have_content 'admin権限が必要です'
  end
end
