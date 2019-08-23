require 'rails_helper'

describe 'Cancel Remote Payment Job' do

  let!(:order) { create(:order) }
  let!(:token) { Rails.application.secrets.job_token }
  context 'when payment doesnt exist' do
    it 'returns not found' do
      get "/job/cancel_remote_payment/5?token=#{token}"
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when payment doesnt have remote' do
    let!(:payment) { create(:payment, :without_gateway_data, payable: order) }
    it 'returns unprocessable entity' do
      get "/job/cancel_remote_payment/#{payment.id}?token=#{token}"
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when payment has remote' do
    it 'returns ok' do
      CreatePayment.call(order, order.amount, 'ticket')
      payment = Payment.first
      get "/job/cancel_remote_payment/#{payment.id}?token=#{token}"
      expect(response).to have_http_status(:ok)
    end
  end
end