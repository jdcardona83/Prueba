class Order < ApplicationRecord
  enum status: { inicial: 0, aceptado: 1, rechazado: 2 }

  validates :customer_id, :product_name, :quantity, :price, :status, presence: true
end
