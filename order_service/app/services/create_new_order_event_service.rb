require 'bunny'

class CreateNewOrderEventService < ApplicationService
  def initialize(order)
    @order = order
  end

  def call
    conn = Bunny.new(hostname: 'localhost')
    conn.start
    channel = conn.create_channel
    queue = channel.queue('order.created')
    channel.default_exchange.publish(@order.to_json, routing_key: queue.name)
    conn.close
  end
end
