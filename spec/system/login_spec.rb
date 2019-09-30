require 'rails_helper'

RSpec.describe 'ログインの処理', type: :system do
  scenario 'admin権限でログイン' do
    create :user, email: 'admin@test.test', password: 'password', admin: true
    visit new_user_session_path
    fill_in 'user_email', with: 'admin@test.test'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'Listing products'
  end

  scenario 'end_user権限でログイン' do
    create :user, email: 'user@test.test', password: 'password', admin: false
    visit new_user_session_path
    fill_in 'user_email', with: 'user@test.test'
    fill_in 'user_password', with: 'password'
    click_button 'ログイン'
    expect(page).not_to have_content 'Listing products'
  end
end
