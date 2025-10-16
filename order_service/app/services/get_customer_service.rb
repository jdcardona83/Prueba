class GetCustomerService < ApplicationService
  def initialize(customer_id)
    @customer_id = customer_id
  end

  def call
    response = HTTParty.get("http://localhost:3001/api/customers/#{@customer_id}")

    if response.code == 200
      JSON.parse(response.body)
    else
      nil
    end
  end
end
