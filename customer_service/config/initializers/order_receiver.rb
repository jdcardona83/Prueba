if Rails.env.development? || Rails.env.production?
  Thread.new do
    sleep 5 # Espera un poco a que Rails inicie
    puts "Iniciando consumidor de eventos de órdenes..."
    OrderReceiveService.new.listen
  end
end
