require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  let(:customer_id) { 1 }

  let(:customer_data) do
    {
      'id' => customer_id,
      'name' => 'Juan Test',
      'email' => 'juan@test.com'
    }
  end

  describe 'GET #index' do
    it 'retorna pedidos para un cliente específico' do
      order = create(:order, customer_id: customer_id)
      get :index, params: { customer_id: customer_id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include(
        include(
          'id' => order.id,
          'customer_id' => customer_id,
          'product_name' => order.product_name
        )
      )
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:order) }

    before do
      allow(GetCustomerService).to receive(:call)
        .with(customer_id.to_s)
        .and_return(customer_data)

      allow(CreateNewOrderEventService).to receive(:call)
    end

    context 'con los parámetros válidos' do
      it 'crea un nuevo pedido' do
        expect {
          post :create, params: { order: valid_attributes }
        }.to change(Order, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(CreateNewOrderEventService).to have_received(:call)
      end
    end

    context 'con los parámetros inválidos' do
      it 'no crea un nuevo pedido' do
        expect {
          post :create, params: { order: valid_attributes.merge(product_name: nil) }
        }.not_to change(Order, :count)

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['errors']).to include("Product name can't be blank")
      end
    end

    context 'cuando el cliente no existe' do
      before do
        allow(GetCustomerService).to receive(:call)
          .with(customer_id.to_s)
          .and_return(nil)
      end

      it 'retorna un estado no encontrado' do
        post :create, params: { order: valid_attributes }
        
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Cliente no encontrado')
      end
    end
  end
end