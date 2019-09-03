require 'rails_helper'

RSpec.describe '商品の登録', type: :system do
  let(:adminuser){create :user, is_admin: true}

  scenario "ログインしてHome画面" do
    sign_in adminuser
    visit root_path
    click_link '商品の登録'
    expect(page).to have_content '商品の登録'
  end
end
