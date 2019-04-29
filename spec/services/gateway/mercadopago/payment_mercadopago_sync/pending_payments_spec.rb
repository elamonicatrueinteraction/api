require 'rails_helper'

RSpec.describe Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments do

  describe 'request pending payment' do

    before do
      order1 = create(:order)
      order1.save
      payment1 = create(:payment, payable_id: order1.id)
      payment2 = create(:payment, payable_id: order1.id)
      payment3 = create(:payment, payable_id: order1.id)
      payment2.status = "cancelled"
      payment3.status = "cancelled"
      payment1.save
      payment2.save
      payment3.save
      @pending_payment = payment1
    end

    it 'should return only pending payments array' do
      response = Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments.call
      expect_size = 1
      expect_status = "pending"

      expect(Payment.all.size).to eql(3)
      expect(response.result.size).to eql(expect_size)
      expect(response.result.first.status).to eql(expect_status)
      expect(response.result.first).to eql(@pending_payment)
    end
  end

end