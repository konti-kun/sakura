FactoryBot.define do
  factory :product do
    name {'サンプル'}
    image {Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/images/sample1.png')) }
    price {100}
    explanation {"この商品の説明です。"}
    is_displayed {true}
    sort_key {0}
  end
end
