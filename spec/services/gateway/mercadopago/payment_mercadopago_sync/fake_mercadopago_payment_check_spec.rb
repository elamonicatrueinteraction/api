require 'rails_helper'

RSpec.describe Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck do


  describe 'request payment to mercadopago' do

    before do
      order1 = create(:order)
      order1.save
      payment1 = create(:payment, payable_id: order1.id)
      payment1.save

      @only_approved = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.new(payment1,0)
      @only_cancelled = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.new(payment1, 1)
      @only_in_progress = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.new(payment1, 2)
      @only_not_found = Gateway::Mercadopago::PaymentMercadopagoSync::FakeMercadopagoPaymentCheck.new(payment1, 3)
    end

    it 'should return approved status payment' do
      response = @only_approved.call
      result = response.result['status']
      status_expect = 'approved'

      expect(result).to eql(status_expect)
    end

    it 'should return cancelled status payment' do
      response = @only_cancelled.call
      result = response.result['status']
      status_expect = 'cancelled'

      expect(result).to eql(status_expect)
    end

    it 'should return in progress status payment' do
      response = @only_in_progress.call
      result = response.result['status']
      status_expect = 'in progress'

      expect(result).to eql(status_expect)
    end

    it 'should return not found' do
      response = @only_not_found.call
      result = response.result[:status]
      status_expect = 404

      expect(result).to eql(status_expect)
    end
  end

end