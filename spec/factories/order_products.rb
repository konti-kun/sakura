FactoryBot.define do
  factory :order_product do
  end
  factory :shopping_product do
  end
  factory :order do
    initialize_with { new(attributes) }
  end
end

