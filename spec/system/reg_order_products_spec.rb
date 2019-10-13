require 'rails_helper'

RSpec.describe 'ショッピングカートの編集', type: :system do
  let(:enduser){create :user, admin: false}
  let(:product){create :product, name: 'サンプル', price: 10}

  scenario 'ログインせずカートに追加しようとするとログイン画面に遷移する' do
      visit product_path product.id
      click_button 'カートに追加'
      expect(page).to have_content 'メールアドレス'
  end

  scenario 'adminユーザでカートに追加しようとするとログイン画面に遷移する' do
      visit product_path product.id
      expect(page).to have_no_content 'カートに追加'
  end

  describe "enduserでログイン後、商品詳細から1個でショッピングカートに登録ができる" do
    before do 
      sign_in enduser
      visit product_path product.id
      click_button 'カートに追加'
    end

    scenario 'ショッピングカートに遷移する' do
      expect(page).to have_content 'ショッピングカート'
    end

    scenario '商品名が表示される' do
      expect(page).to have_content 'サンプル'
    end
    
    scenario '個数が表示される' do
      expect(page).to have_content '1個'
    end

    scenario '値段が表示される' do
      expect(page).to have_content '10円'
    end
  end

  scenario "個数を指定して登録ができる" do
    sign_in enduser
    visit product_path product.id
    fill_in 'order_product_number', with: '10'
    click_button 'カートに追加'
    expect(page).to have_content '10個'
  end

  scenario "0個を指定するとエラーとなる" do
    sign_in enduser
    visit product_path product.id
    fill_in 'order_product_number', with: '0'
    expect{
      click_button 'カートに追加'
    }.not_to change{OrderProduct.count}.from(0)
  end

  scenario "削除ボタンで削除できる" do
    sign_in enduser
    visit product_path product.id
    click_button 'カートに追加'
    click_link '削除する'
    expect(page).to have_no_content 'サンプル'
  end

  describe "同じ商品を一度に登録できない" do
    before do
      sign_in enduser
      visit product_path product.id
      click_button 'カートに追加'
      visit product_path product.id
    end

    scenario 'エラーメッセージが表示される' do
      click_button 'カートに追加'
      expect(page).to have_content "この商品はすでにカートに追加されています。"
    end

    scenario 'データが登録されてない' do
      expect{
        click_button 'カートに追加'
      }.not_to(
        change{ OrderProduct.count }.from(1)
      )
    end
  end

end

