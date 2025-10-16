## Requiere

* Ruby versión 3.3.5
* Rails versión 7.2.2.2
* PostgreSQL
* RabbitMQ

## Contenido del repositorio

Este repositorio contiene los siguientes microservicios:
- order_service:
  realiza las siguientes acciones:
    - Crea pedidos: por medio del endpoint http://localhost:3000/api/orders
      ejemplo de petición POST:
      {
        "customer_id": 3,
        "product_name": "Panela",
        "quantity": 60,
        "price": 6000,
        "status": "inicial"
      }

    - Consulta pedidos para un cliente:
      ejemplo de petición GET:
      http://localhost:3000/api/orders?customer_id=3

    - Se conecta con customer_service, la lógica se encuentra en: order_service/app/services/get_customer_service.rb
 
    - Emite un evento al momento de crear un pedido, la lógica se encuentra en: order_service/app/services/create_new_order_event_service.rb
      
- customer_service:
    - Permite la consulta de la información de un cliente: http://localhost:3001/api/customers/3
 
    - Tiene predefinida una información en: customer_service/db/seeds.rb

## Especificaciones técnicas

* order_service y customer_service se comunican por medio de una llamada HTTP, se usó la gema HTTParty.
  
* Se usó una arquitectura basada en eventos, con dos microservicios independientes que se comunican por medio de RabbitMQ

* Se usó RSPec para las pruebas, adicionalmente se usaron las gemas: fake (datos de prueba), factory_bot (crear instancias de prueba), shoulda-matchers (simplificar el código de las pruebas). Los archivos de las pruebas se pueden encontrar en la carpeta /spec de cada microservicio.

## Instrucciones de ejecución
  * Verificar en el archivo  /config/database.yml de cada microservicio la configuración del usuario y password local para postgresql.

  * order_service: corre en el puerto 3000
  ```bash
  cd order_service
  bundle install
  rails db:create
  rails db:migrate
  rails s
  ```

  * customer_service: corre en el puerto 3001
  ```bash
  cd customer_service
  bundle install
  rails db:create
  rails db:migrate
  rails db:seeds
  rails s
  ```

  * Realizar la petición POST a http://localhost:3000/api/orders con la información para crear un pedido.

## Diagrama

![Diagrama](/Diagrama.png)
