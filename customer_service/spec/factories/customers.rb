FactoryBot.define do
  factory :customer do
    customer_name { Faker::Name.name }
    address { Faker::Address.full_address }
    orders_count { rand(0..10) }
  end
end
