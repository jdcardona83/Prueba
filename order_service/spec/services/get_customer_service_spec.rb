require 'rails_helper'

RSpec.describe GetCustomerService, type: :service do
  let(:customer_id) { 1 }
  let(:customer_data) do
    {
      'id' => customer_id,
      'name' => 'Juan Pérez',
      'email' => 'juan@example.com'
    }
  end

  describe '#call' do
    context 'cuando el cliente existe' do
      let(:http_response) { double('HTTParty::Response', code: 200, body: customer_data.to_json) }

      before do
        allow(HTTParty).to receive(:get).with("http://localhost:3001/api/customers/#{customer_id}").
          and_return(http_response)
      end

      it 'retorna los datos del cliente' do
        result = described_class.call(customer_id)
        expect(result).to eq(customer_data)
      end
    end

    context 'cuando el cliente no existe' do
      let(:http_response) { double('HTTParty::Response', code: 404, body: '') }

      before do
        allow(HTTParty).to receive(:get).with("http://localhost:3001/api/customers/#{customer_id}").
          and_return(http_response)
      end

      it 'retorna nil' do
        result = described_class.call(customer_id)
        expect(result).to be_nil
      end
    end
  end
end
