class Customer < ApplicationRecord
  validates :customer_name, :address, presence: true
end
