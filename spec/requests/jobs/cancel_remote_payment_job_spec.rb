require 'rails_helper'

describe 'Cancel Remote Payment Job' do

  let!(:order) { create(:order) }
  let!(:token) { Rails.application.secrets.job_token }
  context 'when payment doesnt exist' do
    it 'returns ok and writes db result' do
      get "/job/cancel_remote_payment/5?token=#{token}"
      expect(response).to have_http_status(:ok)
      expect(JobResult.count).to eq(1)
      expect(JobResult.first.name).to_not be_nil
      expect(JobResult.first.result).to eq(JobResult::Types::FAILED)
    end
  end

  context 'when payment doesnt have remote' do
    let!(:payment) { create(:payment, :without_gateway_data, payable: order) }
    it 'returns ok and writes db result' do
      get "/job/cancel_remote_payment/#{payment.id}?token=#{token}"
      expect(response).to have_http_status(:ok)
      expect(JobResult.count).to eq(1)
      expect(JobResult.first.name).to_not be_nil
      expect(JobResult.first.result).to eq(JobResult::Types::FAILED)
    end
  end

  context 'when payment has remote' do
    it 'returns ok' do
      CreatePayment.call(payable: order, amount: order.amount, payment_type: 'ticket')
      payment = Payment.first
      get "/job/cancel_remote_payment/#{payment.id}?token=#{token}"
      expect(response).to have_http_status(:ok)
      expect(JobResult.count).to eq(1)
      expect(JobResult.first.name).to_not be_nil
      expect(JobResult.first.result).to eq(JobResult::Types::SUCCESSFUL)
    end
  end
end