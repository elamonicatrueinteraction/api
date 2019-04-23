require 'rails_helper'

RSpec.describe Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments do

  describe 'request pending payment' do
    it 'should return a payments array' do
      response = Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments.call
      expect_result = Payment.select {|x| x.status == "pending"}

      expect(response.to contain_exactly(expect_result))
    end
  end

end