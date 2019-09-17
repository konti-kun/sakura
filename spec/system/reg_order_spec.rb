require 'rails_helper'

RSpec.describe '購入手続きの登録', type: :system do
  let(:user){create :user, is_admin: false }
  let(:enduser){create :end_user, user: user, name: '桜太郎', address: '神奈川県' }
  let(:product1){create :product, name:'サンプル１', price:10}
  let(:product2){create :product, name:'サンプル２', price:20}

  scenario "選択した商品が０個だと購入手続きに遷移しない" do
      sign_in enduser.user
      visit order_products_path
      click_link '購入手続きへ'
      expect(page).to have_content '商品を選択してください。'
  end

  describe "購入手続きに遷移する" do
    before do
      create :order_product, user: enduser.user, product: product1, number: 1
      create :order_product, user: enduser.user, product: product2, number: 1
      sign_in enduser.user
      visit order_products_path
      click_link '購入手続きへ'
    end

    scenario "購入対象の商品を表示している" do
      expect(page).to have_content 'サンプル１'
      expect(page).to have_content 'サンプル２'
      expect(page).to have_content '1個'
      expect(page).to have_content '10円'
    end
  end
  describe "購入手続き画面で商品金額合計を表示する" do
    before do
      sign_in enduser.user
      visit order_products_path
    end

    scenario "1商品1個の場合" do
      create :order_product, user: enduser.user, product: product1, number: 1
      click_link '購入手続きへ'
      expect(find("#total_product_price_value")).to have_content '10円'
    end

    scenario "1商品2個の場合" do
      create :order_product, user: enduser.user, product: product1, number: 2
      click_link '購入手続きへ'
      expect(find("#total_product_price_value")).to have_content '20円'
    end

    scenario "2商品2個ずつの場合" do
      create :order_product, user: enduser.user, product: product1, number: 2
      create :order_product, user: enduser.user, product: product2, number: 2
      click_link '購入手続きへ'
      expect(find("#total_product_price_value")).to have_content '60円'
    end
  end
  describe "購入手続き画面で代引き手数料を表示する" do
    before do
      sign_in enduser.user
      visit order_products_path
    end

    scenario "10000円以下の場合" do
      create :order_product, user: enduser.user, product: product1, number: 1
      click_link '購入手続きへ'
      expect(find("#cod_value")).to have_content '300円'
    end

    scenario "10000円の場合" do
      create :order_product, user: enduser.user, product: product1, number: 1000
      click_link '購入手続きへ'
      expect(find("#cod_value")).to have_content '400円'
    end
    scenario "10010円の場合" do
      create :order_product, user: enduser.user, product: product1, number: 1001
      click_link '購入手続きへ'
      expect(find("#cod_value")).to have_content '400円'
    end
    scenario "30000円の場合" do
      create :order_product, user: enduser.user, product: product1, number: 3000
      click_link '購入手続きへ'
      expect(find("#cod_value")).to have_content '600円'
    end
    scenario "100000円の場合" do
      create :order_product, user: enduser.user, product: product1, number: 10000
      click_link '購入手続きへ'
      expect(find("#cod_value")).to have_content '1000円'
    end
    scenario "100000円以上の場合" do
      create :order_product, user: enduser.user, product: product1, number: 11000
      click_link '購入手続きへ'
      expect(find("#cod_value")).to have_content '1000円'
    end
  end

  describe "購入手続き画面で送料を表示する" do
    before do
      sign_in enduser.user
      visit order_products_path
    end

    scenario "1商品1個の場合" do
      create :order_product, user: enduser.user, product: product1, number: 1
      click_link '購入手続きへ'
      expect(find("#send_fee_value")).to have_content '600円'
    end

    scenario "1商品５個の場合" do
      create :order_product, user: enduser.user, product: product1, number: 5
      click_link '購入手続きへ'
      expect(find("#send_fee_value")).to have_content '600円'
    end
    scenario "1商品6個の場合" do
      create :order_product, user: enduser.user, product: product1, number: 6
      click_link '購入手続きへ'
      expect(find("#send_fee_value")).to have_content '1200円'
    end
    scenario "2商品6個の場合" do
      create :order_product, user: enduser.user, product: product1, number: 5
      create :order_product, user: enduser.user, product: product2, number: 1
      click_link '購入手続きへ'
      expect(find("#send_fee_value")).to have_content '1200円'
    end
  end

  scenario "購入手続き画面で合計値を表示する" do
      sign_in enduser.user
      visit order_products_path
      create :order_product, user: enduser.user, product: product1, number: 1
      click_link '購入手続きへ'
      expect(find("#total_price_value")).to have_content "982円"
  end

  describe "発送可能日が営業日3日から１４日であること" do
    before do
      sign_in enduser.user
      visit order_products_path
    end

    scenario "今日が月曜日の場合" do
      create :order_product, user: enduser.user, product: product1, number: 1
      current_time = "2019-09-16 23:00".to_time
      travel_to current_time do
        click_link '購入手続きへ'
      end
      expect(page).to have_select '発送日', options: [""] + %w(2019-09-19 2019-09-20 2019-09-23 2019-09-24 2019-09-25 2019-09-26 2019-09-27 2019-09-30 2019-10-01 2019-10-02 2019-10-03 2019-10-04)
    end

  end

  scenario "発送日は必須であること" do
    create :order_product, user: enduser.user, product: product1, number: 1
    sign_in enduser.user
    visit order_products_path
    click_link '購入手続きへ'
    click_button '決定'
    expect(find("div.order_send_date")).to have_content "を入力してください"
  end

  scenario "発送時間帯は必須であること" do
    create :order_product, user: enduser.user, product: product1, number: 1
    sign_in enduser.user
    visit order_products_path
    click_link '購入手続きへ'
    click_button '決定'
    expect(find("div.order_send_timeframe")).to have_content "を入力してください"
  end

  describe "購入手続きが完了していること" do
    before do
      create :order_product, user: enduser.user, product: product1, number: 1
      sign_in enduser.user
      visit order_products_path
      current_time = "2019-09-16 23:00".to_time
      travel_to current_time do
        click_link '購入手続きへ'
        select '2019-09-19', from: '発送日'
        select '8 - 12', from: '発送時間帯'
        click_button '決定'
      end
    end

    scenario "購入が完了したメッセージがでる" do
      expect(page).to have_content '購入処理が完了しました。'
    end
    scenario "ユーザがログインユーザ" do
      expect(Order.first.user.id).to eq enduser.user.id
    end
    scenario "nameがログインユーザの名前" do
      expect(Order.first.name).to eq enduser.name
    end
    scenario "addressがログインユーザのaddress" do
      expect(Order.first.address).to eq enduser.address
    end
    scenario "発送日が2019-09-19" do
      expect(Order.first.send_date).to eq '2019-09-19'.to_date
    end
    scenario "発送時間帯が0" do
      expect(Order.first.send_timeframe).to eq '8 - 12'
    end
    scenario "合計が982" do
      expect(Order.first.total_fee).to eq 982
    end
    scenario "Orderの主キーがOrderProductに設定されている" do
      expect(OrderProduct.first.order_id).to eq Order.first.id
    end
  end

  scenario "購入手続き中に新たにProductが追加されていてもOrder対象にはならないこと" do
    create :order_product, user: enduser.user, product: product1, number: 1
    sign_in enduser.user
    visit order_products_path
    current_time = "2019-09-16 23:00".to_time
    travel_to current_time do
      click_link '購入手続きへ'
      order_product2 = create :order_product, user: enduser.user, product: product2, number: 1
      select '2019-09-19', from: '発送日'
      select '8 - 12', from: '発送時間帯'
      click_button '決定'
      expect(order_product2.order_id).to eq nil
    end
  end

  scenario "購入処理中に金額変更された時、エラーになり、再確認させること" do
    create :order_product, user: enduser.user, product: product1, number: 1
    sign_in enduser.user
    visit order_products_path
    current_time = "2019-09-16 23:00".to_time
    travel_to current_time do
      click_link '購入手続きへ'
      product1.price = 100
      product1.save
      select '2019-09-19', from: '発送日'
      select '8 - 12', from: '発送時間帯'
      click_button '決定'
      expect(page).to have_content "更新処理中に金額に変更がありました。金額をお確かめの上、再度購入処理をお願いします。"
      expect(Order.count).to eq 0
    end
  end
  
  scenario "購入処理中に対象商品が変更された時、エラーになり、再確認させること" do
    order_product = create :order_product, user: enduser.user, product: product1, number: 1
    sign_in enduser.user
    visit order_products_path
    current_time = "2019-09-16 23:00".to_time
    travel_to current_time do
      click_link '購入手続きへ'
      order_product.order_id = 1
      order_product.save
      select '2019-09-19', from: '発送日'
      select '8 - 12', from: '発送時間帯'
      click_button '決定'
      expect(page).to have_content "をお確かめの上、再度購入処理をお願いします。"
      expect(Order.count).to eq 0
    end
  end

end
