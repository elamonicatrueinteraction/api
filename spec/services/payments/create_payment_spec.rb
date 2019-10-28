require 'rails_helper'

describe 'Create Payment' do

  let!(:order) { create(:order, amount: 0) }
  let!(:gateway_router) { spy('gateway_router')}

  context 'when amount is 0' do
    context 'when fake remote creator is used' do
      it 'creates an exempt payment and doesnt call remote creator' do
        creator = Payments::CreatePayment.new(gateway_router: gateway_router)
        creator.create(payable: order, amount: order.amount, payment_type: 'rapipago')
        expect(gateway_router).to_not have_received(:route_gateway)
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
