require 'rails_helper'

RSpec.describe Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck do

  describe 'request payment to mercadopago' do

    before do
      order1 = create(:order)
      order1.save
      payment1 = create(:payment, payable_id: order1.id)
      payment1.save
      @pending_payment = payment1
    end

    it 'should return approved status payment' do
      response = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.call(@pending_payment, "approved")
      result = response.result['status']
      status_expect = 'approved'

      expect(result).to eql(status_expect)
    end

    it 'should return cancelled status payment' do
      response = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.call(@pending_payment, "cancelled")
      result = response.result['status']
      status_expect = 'cancelled'

      expect(result).to eql(status_expect)
    end

    it 'should return pending status payment' do
      response = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.call(@pending_payment, "pending")
      result = response.result['status']
      status_expect = 'pending'

      expect(result).to eql(status_expect)
    end
  end

end