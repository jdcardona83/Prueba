require 'bunny'

class OrderReceiveService < ApplicationService
  def initialize
    @conn = Bunny.new(hostname: 'localhost')
    @conn.start
    @channel = @conn.create_channel
    @queue = @channel.queue('order.created')
  end

  def listen
    @queue.subscribe(block: true) do |_delivery_info, _properties, body|
      data = JSON.parse(body)
      puts "Received order: #{data}"

      process_order(data)
    end
  rescue Interrupt => _
    @conn.close
  end

  private

  def process_order(data)
    customer = Customer.find_by(id: data['customer_id'])

    if customer
      customer.update(orders_count: customer.orders_count + 1)
      puts "Cliente #{customer.id} actualizado con #{customer.orders_count} órdenes."
    else
      puts "Cliente con ID #{data['customer_id']} no encontrado."
    end
  end
end
