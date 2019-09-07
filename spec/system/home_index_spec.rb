require 'rails_helper'

RSpec.describe 'エンドユーザ向け商品一覧', type: :system do

  scenario "is_display=trueのもののみ表示される" do
    create :product, name: 'サンプル1', is_displayed: true
    create :product, name: 'サンプル2', is_displayed: false
    visit root_path
    expect(page).to have_content 'サンプル1'
    expect(page).to have_no_content 'サンプル2'
  end
  scenario "sort_keyの昇順で表示される" do
    create :product, name: 'サンプル1', sort_key: 2
    create :product, name: 'サンプル2', sort_key: 1
    create :product, name: 'サンプル3', sort_key: 3
    visit root_path
    expect(find_all('.card-title  a')[0]).to have_content 'サンプル3'
    expect(find_all('.card-title  a')[1]).to have_content 'サンプル1'
    expect(find_all('.card-title  a')[2]).to have_content 'サンプル2'
  end
end

