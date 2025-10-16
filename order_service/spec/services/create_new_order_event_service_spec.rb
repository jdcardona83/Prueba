require 'rails_helper'

RSpec.describe CreateNewOrderEventService, type: :service do
  let(:order) { create(:order) }
  let(:bunny_conn) { double(Bunny, start: true, create_channel: channel, close: true) }
  let(:channel) { double('Channel', queue: queue, default_exchange: exchange) }
  let(:queue) { double('Queue', name: 'order.created') }
  let(:exchange) { double('Exchange', publish: true) }

  before do
    allow(Bunny).to receive(:new).and_return(bunny_conn)
  end

  it 'publica la orden en la cola correcta' do
    expect(exchange).to receive(:publish).with(order.to_json, routing_key: 'order.created')
    described_class.new(order).call
  end

  it 'cierra la conexión de Bunny' do
    expect(bunny_conn).to receive(:close)
    described_class.new(order).call
  end
end
