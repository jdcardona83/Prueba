customers = [
  { customer_name: "Juan Pérez", address: "Calle 123, Bogotá", orders_count: 5 },
  { customer_name: "María López", address: "Carrera 45, Medellín", orders_count: 2 },
  { customer_name: "Carlos Ruiz", address: "Av. 7 No. 89, Cali", orders_count: 7 }
]

customers.each do |attrs|
  Customer.find_or_create_by!(customer_name: attrs[:customer_name]) do |c|
    c.address = attrs[:address]
    c.orders_count = attrs[:orders_count]
  end
end

puts "Clientes precargados: #{Customer.count}"
