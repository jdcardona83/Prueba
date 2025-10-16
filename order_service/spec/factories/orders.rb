FactoryBot.define do
  factory :order do
    customer_id { 1 }
    product_name { "Laptop" }
    quantity { 2 }
    price { 5000 }
    status { "aceptado" }
  end
end
