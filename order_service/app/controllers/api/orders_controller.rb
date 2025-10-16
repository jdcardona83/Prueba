module Api
  class OrdersController < ApplicationController
    before_action :set_customer, only: :create

    def index
      orders = Order.where(customer_id: params[:customer_id])

      render json: orders
    end

    def create
      order = Order.new(order_params)

      if order.save
        create_new_order_event(order)

        render json: order, status: :created
      else

        render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def order_params
      params.require(:order).permit(:customer_id, :product_name, :quantity, :price, :status)
    end

    def set_customer
      @customer = GetCustomerService.call(params[:order][:customer_id])

      render json: { error: 'Cliente no encontrado' }, status: :not_found unless @customer
    end

    def create_new_order_event(order)
      CreateNewOrderEventService.call(order)
    end
  end
end
