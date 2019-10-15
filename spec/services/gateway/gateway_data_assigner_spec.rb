require 'rails_helper'

describe 'Gateway data assignment to Payment' do

  let!(:order) { create(:order) }
  let!(:payment) { create(:payment, :without_gateway_data, payable: order) }
  let!(:assigner) { Gateway::GatewayDataAssigner.new }

  context 'when mercadopago response is 201' do
    it "fills payment fields and makes payment status 'pending'" do
      response = JSON.parse(File.read("spec/fixtures/created_mercadopago_response.json"))
      data = Gateway::Mercadopago::Data.new(response)
      meli_payment = assigner.assign(payment, data)
      expect(meli_payment.status).to eq('pending')
      expect(meli_payment.gateway_id).not_to be_nil
      expect(meli_payment.gateway).not_to be_nil
      expect(meli_payment.gateway_data).not_to eq({})
    end
  end

  context 'when mercadopago response is 400' do
    it "makes payment status 'pending' and gateway_id 'nil'" do
      response = JSON.parse(File.read("spec/fixtures/bad_request_mercadopago_response.json"))
      data = Gateway::Mercadopago::Data.new(response)
      meli_payment = assigner.assign(payment, data)
      expect(meli_payment.status).to eq(Payment::Types::ERROR)
      expect(meli_payment.gateway_id).to be_nil
    end
  end
end