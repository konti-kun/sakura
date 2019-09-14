require 'rails_helper'

RSpec.describe '購入手続きの登録', type: :system do
  let(:enduser){create :user, is_admin: false}

  describe "購入手続きに遷移する" do
    sign_in enduser
    visit root_path
  end
end
