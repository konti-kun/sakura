require 'rails_helper'

RSpec.describe '商品詳細', type: :system do
  let(:adminuser){create :user, is_admin: true}
  let(:enduser){create :user, is_admin: false}
  let(:product){create :product, name: 'サンプル'}

  scenario "adminユーザの場合、編集のリンクがある" do
    sign_in adminuser
    visit product_path product.id
    expect(page).to have_link '編集'
  end
  scenario "adminユーザの場合、編集画面に遷移できる" do
    sign_in adminuser
    visit product_path product.id
    expect(page).to have_content 'サンプル'
  end
  scenario "エンドユーザの場合、編集のリンクがない" do
    sign_in enduser
    visit product_path product.id
    expect(page).to have_no_link '編集'
  end
  scenario "エンドユーザの場合、編集画面に遷移できない" do
    sign_in enduser
    expect{visit edit_product_path product.id}.to raise_error(ProductsController::PermissionError)
  end
  scenario "ログインしてない場合、編集のリンクがない" do
    visit product_path product.id
    expect(page).to have_no_link '編集'
  end
  scenario "ログインしてない場合、編集画面に遷移できない" do
    expect{visit edit_product_path product.id}.to raise_error(ProductsController::PermissionError)
  end
end
