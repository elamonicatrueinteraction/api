require 'rails_helper'
require 'helpers/fake_data'

RSpec.describe "Update payment with gateway data" do

  let!(:order) { create(:order) }
  let!(:payment) { create(:payment, payable: order) }
  let!(:institution) { Services::Institution.find(order.giver_id) }

  context 'when status is approved' do
    let!(:approved_json_data) { JSON.parse(File.read("spec/fixtures/paid_mercadopago_response.json")) }
    let!(:data) { FakeData.new(payment: payment, status: Payment::Types::APPROVED,
                               paid_at: Time.now, total_fees: 5, raw_data: approved_json_data) }

    it 'should update make payment approved and update collected amount' do
      result = Gateway::UpdatePayment.call(payment, data).result
      expect(result.status).to eq(Payment::Types::APPROVED)
      expect(result.collected_amount).to eq(payment.amount)
    end
  end

  context 'when status is cancelled' do
    let!(:cancelled_json_data) { JSON.parse(File.read("spec/fixtures/cancelled_mercadopago_response.json")) }
    let!(:data) { FakeData.new(payment: payment, status: Payment::Types::CANCELLED,
                               paid_at: nil, total_fees: nil, raw_data: cancelled_json_data) }

    it 'should update payment status' do
      result = Gateway::UpdatePayment.call(payment, data).result
      expect(result.status).to eq(Payment::Types::CANCELLED)
      expect(result.collected_amount).to be_nil
    end
  end

  context 'when status is pending' do
    let!(:pending_json_data) { JSON.parse(File.read("spec/fixtures/created_mercadopago_response.json")) }
    let!(:data) { FakeData.new(payment: payment, status: Payment::Types::PENDING,
                               paid_at: nil, total_fees: nil, raw_data: pending_json_data) }

    it 'should update payment status' do
      result = Gateway::UpdatePayment.call(payment, data).result
      expect(result.status).to eq(Payment::Types::PENDING)
      expect(result.collected_amount).to be_nil
    end
  end

end
