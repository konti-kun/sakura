require 'rails_helper'

RSpec.describe 'エンドユーザの登録', type: :system do
  describe '正しい値を入れることでDBの' do
    before do
      visit new_user_registration_path

      fill_in 'user_email', with: "testuser@test.test"
      fill_in 'user_password', with: "password"
      fill_in 'user_password_confirmation', with: "password"
      fill_in 'user_end_user_attributes_name', with: "佐藤太郎"
      fill_in 'user_end_user_attributes_address', with: "神奈川県横浜市"
    end

    scenario "Userデータが作成されている" do
      expect{
        click_button "登録"
      }.to(
        change{ User.count }.from(0).to(1)
      )
    end
    scenario "EndUserデータが作成されている" do
      expect{
        click_button "登録"
      }.to(
        change{ EndUser.count }.from(0).to(1)
      )
    end
  end

end

