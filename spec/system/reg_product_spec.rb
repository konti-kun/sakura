require 'rails_helper'

RSpec.describe '商品の登録', type: :system do
  let(:adminuser) { create :user, admin: true }
  let(:enduser) { create :user, admin: false }

  scenario 'adminユーザでログインすると商品の登録メニューがありクリックすると画面遷移する' do
    sign_in adminuser
    visit root_path
    click_link '商品の登録'
    expect(page).to have_content '商品の登録'
  end

  scenario 'enduserでログインしても商品の登録ボタンが存在しない' do
    sign_in enduser
    visit root_path
    expect(page).to have_no_link '商品の登録'
  end

  scenario 'enduserでは商品追加はできない' do
    sign_in enduser
    visit new_admin_product_path
    expect(page).to have_content 'admin権限が必要です'
  end

  scenario '商品の登録を行う' do
    sign_in adminuser
    visit new_admin_product_path
    fill_in 'product_name', with: 'サンプル'
    attach_file 'product[image]', "#{Rails.root}/spec/fixtures/images/sample1.png"
    fill_in 'product_price', with: '10'
    fill_in 'product_explanation', with: 'サンプルの説明です。'
    check 'product[is_displayed]'
    fill_in 'product_sort_key', with: '1'

    expect do
      click_button '登録する'
    end.to change { Product.count }.from(0)
  end

  scenario '商品の登録でエラーになる' do
    sign_in adminuser
    visit new_admin_product_path
    fill_in 'product_name', with: 'サンプル'
    attach_file 'product[image]', "#{Rails.root}/spec/fixtures/images/sample1.png"
    fill_in 'product_price', with: 'aa'
    fill_in 'product_explanation', with: 'サンプルの説明です。'
    check 'product[is_displayed]'
    fill_in 'product_sort_key', with: '1'
    expect do
      click_button '登録する'
    end.not_to change { Product.count }.from(0)
  end

  scenario '商品の変更でエラーになる' do
    sign_in adminuser
    create :product, price: '100'
    visit admin_products_path
    click_link 'Edit'
    expect do
      fill_in 'product_price', with: 'aa'
      click_button '更新する'
    end.not_to change { Product.first.price }.from(100)
  end
  scenario '商品の変更を行う' do
    sign_in adminuser
    create :product, price: '100'
    visit admin_products_path
    click_link 'Edit'
    expect do
      fill_in 'product_price', with: 10
      click_button '更新する'
    end.to change { Product.first.price }.from(100).to(10)
  end

  scenario '商品の削除を行う' do
    sign_in adminuser
    create :product
    visit admin_products_path
    expect do
      click_link 'Destroy'
    end.to change { Product.count }.from(1).to(0)
  end
end
