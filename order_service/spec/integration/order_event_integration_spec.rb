require 'rails_helper'
require 'bunny'

RSpec.describe 'Order Event Integration', type: :integration do
  let(:order) { create(:order) }
  
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

  it 'publica un evento de pedido en la cola de RabbitMQ' do
    messages = []

    @queue.subscribe(block: false) do |_delivery_info, _properties, body|
      messages << JSON.parse(body)
    end

    CreateNewOrderEventService.call(order)
    sleep 1

    expect(messages.size).to eq(1)
    published_message = messages.first

    expect(published_message).to include(
      'id' => order.id,
      'customer_id' => order.customer_id,
      'product_name' => order.product_name,
      'quantity' => order.quantity,
      'price' => order.price.to_s,
      'status' => order.status
    )
  end

  it 'mantiene la conexión a RabbitMQ estable durante la publicación' do
    expect {
      CreateNewOrderEventService.call(order)
    }.not_to raise_error

    expect(@conn.connected?).to be true
  end

  it 'cierra la conexión después de publicar' do
    connection_spy = spy('connection')
    allow(Bunny).to receive(:new).and_return(connection_spy)
    allow(connection_spy).to receive_messages(
      start: true,
      create_channel: @channel,
      close: true
    )

    CreateNewOrderEventService.call(order)

    expect(connection_spy).to have_received(:close)
  end
end