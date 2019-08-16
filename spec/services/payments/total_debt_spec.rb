require 'rails_helper'
require 'securerandom'

describe 'Total Debt Calculation' do

  let(:debt_calculator) { Payments::TotalDebt.new }
  let!(:institution) {
    institution = OpenStruct.new
    institution.id = '37d4970a-53ea-49f5-a2f1-2cdf26f36454'
    institution
  }

  context 'when institution doesnt have orders or deliveries' do

    before do
      Order.destroy_all
      Delivery.destroy_all
      Payment.destroy_all
    end

    it 'doesnt have debt' do
      expect(debt_calculator.calculate(institution)).to eq(0)
    end
  end

  context 'when orders and deliveries exist' do
    let!(:order) { create(:order_with_pending_payment, amount:1, bonified_amount:0, receiver_id: institution.id) }
    let!(:delivery) { create(:delivery_with_pending_payment, amount: 200, bonified_amount: 0, order: order) }
    let!(:payed_order) {
      create(:order_with_approved_payment, amount: 9, bonified_amount: 0, receiver_id: institution.id)
    }
    let!(:payed_delivery) {create(:delivery_with_approved_payment, amount: 58, bonified_amount: 0, order: order)}

    context 'when institution has 1 paid order, 1 paid delivery, 1 pending order and 1 pending delivery' do
      it 'has only the pending as debt' do
        expect(debt_calculator.calculate(institution)).to eq(order.total_amount + delivery.total_amount)
      end
    end
  end
end