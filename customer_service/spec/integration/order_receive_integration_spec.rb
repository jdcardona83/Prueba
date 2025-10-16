require 'rails_helper'
require 'bunny'

RSpec.describe 'Order Receive Integration', type: :integration do
  let(:order_data) do
    {
      id: 1,
      customer_id: 1,
      product_name: 'Coca Cola',
      quantity: 1,
      price: 100.0,
      status: 'inicial'
    }
  end

  let!(:customer) do
    Customer.create!(id: order_data[:customer_id], customer_name: 'Juan Perez', 
      address: 'Calle Falsa 123', orders_count: 0)
  end

  before(:all) do
    @conn = Bunny.new(hostname: 'localhost')
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue('order.created')
    @queue.purge
  end

  after(:all) do
    @queue.purge
    @channel.close
    @conn.close
  end

  it 'procesa correctamente un mensaje de orden recibido' do
    @channel.default_exchange.publish(
      order_data.to_json,
      routing_key: @queue.name,
      content_type: 'application/json',
      delivery_mode: 2
    )

    receiver_thread = Thread.new do
      OrderReceiveService.new.listen
    end

    sleep 1
    receiver_thread.kill
    receiver_thread.join

    customer.reload
    expect(customer.orders_count).to eq(1)
  end

  it 'maneja correctamente clientes no encontrados' do
    messages = []
    allow($stdout).to receive(:puts) do |message|
      messages << message
    end

    invalid_order_data = order_data.merge(customer_id: 999)

    @channel.default_exchange.publish(
      invalid_order_data.to_json,
      routing_key: @queue.name
    )

    receiver_thread = Thread.new do
      OrderReceiveService.new.listen
    end

    sleep 1
    receiver_thread.kill
    receiver_thread.join

    expect(messages).to include("Cliente con ID 999 no encontrado.")
  end
end
