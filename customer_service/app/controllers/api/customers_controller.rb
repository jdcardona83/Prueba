module Api
  class CustomersController < ApplicationController
    def show
      customer = Customer.find_by(id: params[:id])

      if customer
        render json: customer, status: :ok
      else
        render json: { error: 'Cliente no encontrado' }, status: :not_found
      end
    end
  end
end
