require 'rails_helper'

RSpec.describe "Pending payments query" do

  let!(:order) { create(:order) }
  let!(:cancelled_payment) { create(:payment, payable: order, status: Payment::Types::CANCELLED)}
  let!(:another_cancelled_payment) { create(:payment, payable: order, status: Payment::Types::CANCELLED)}
  let!(:pending_payment) { create(:payment, payable: order, status: Payment::Types::PENDING) }

  it 'should return only pending payments array' do
    pending_payments = Payments::PendingPayments.call

    expect(Payment.all.length).to eql(3)
    expect(pending_payments.result.size).to eql(1)
    expect(pending_payments.result.first.status).to eq(Payment::Types::PENDING)
    expect(pending_payments.result.first).to eql(pending_payment)
  end
end