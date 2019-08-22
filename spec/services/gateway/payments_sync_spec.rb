require 'rails_helper'
require 'helpers/fake_data'
require 'helpers/stub_gateway'
require 'helpers/stub_gateway_provider'

RSpec.describe "Payment sync with remote provider" do

  let!(:order) {create(:order)}
  let!(:cancelled_payment) { create(:payment, payable: order, status: Payment::Types::CANCELLED) }
  let!(:pending_payment) { create(:payment, payable: order) }
  let!(:another_pending_payment) { create(:payment, payable: order) }
  let!(:institution) { Services::Institution.find(order.giver_id) }
  let!(:approved_json_data) { JSON.parse(File.read("spec/fixtures/paid_mercadopago_response.json")) }
  let!(:cancelled_json_data) { JSON.parse(File.read("spec/fixtures/cancelled_mercadopago_response.json")) }

  context "when all payments exist in remote" do
    it 'should update only payment with state approved' do
      provider = make_stub_provider
      total_debt_init = institution.calculated_total_debt
      Gateway::PaymentSync.new(gateway_provider: provider).sync_payments
      total_debt_final = institution.calculated_total_debt
      total_debt_expect = total_debt_init - (pending_payment.amount + another_pending_payment.amount)

      expect(total_debt_final).to eql(total_debt_expect)
      expect(Payment.find(pending_payment.id).status).to eql(Payment::Types::APPROVED)
      expect(Payment.find(another_pending_payment.id).status).to eql(Payment::Types::APPROVED)
      expect(Payment.find(cancelled_payment.id).status).to eql(Payment::Types::CANCELLED)
    end
  end

  def make_stub_provider
    cancelled_data = FakeData.new(payment: cancelled_payment, status: Payment::Types::CANCELLED,
                                         paid_at: nil, total_fees: nil, raw_data: approved_json_data)
    approved_data = FakeData.new(payment: pending_payment, status: Payment::Types::APPROVED,
                                        paid_at: Time.now, total_fees: 5, raw_data: approved_json_data)
    another_approved_data = FakeData.new(payment: another_pending_payment, status: Payment::Types::APPROVED,
                                                paid_at: Time.now, total_fees: 5, raw_data: approved_json_data)
    hash = {
      cancelled_payment.gateway_id => cancelled_data,
      pending_payment.gateway_id => approved_data,
      another_pending_payment.gateway_id => another_approved_data
    }
    client = StubGateway.new(id_response_data: hash)
    StubGatewayProvider.new(client)
  end
end