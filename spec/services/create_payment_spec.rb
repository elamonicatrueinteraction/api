require 'rails_helper'

xdescribe 'Create Payment' do

  let!(:order) { create(:order, amount: 0) }
  let!(:remote_creator) { spy('remote_creator')}

  context 'when amount is 0' do
    context 'when fake remote creator is used' do
      it 'creates an exempt payment and doesnt call remote creator' do
        CreatePayment.call(payable: order, amount: order.amount, payment_type: 'ticket', gateway_creator: remote_creator)
        expect(remote_creator).to_not have_received(:create)
        expect(Payment.all.length).to eq(1)
        expect(Order.first.payments.length).to eq(1)
        payment = Payment.first
        expect(payment.status).to eq(Payment::Types::APPROVED)
        expect(payment.collected_amount).to eq(0)
        expect(payment.amount).to eq(0)
        expect(payment.gateway_id).to be_nil
      end
    end
  end
end