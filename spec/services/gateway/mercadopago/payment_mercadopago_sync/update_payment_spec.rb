require 'rails_helper'

RSpec.describe Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment do

  before do
    order1 = create(:order)
    order1.save
    payment1 = create(:payment, payable_id: order1.id)
    payment1.save
    @pending_payment = payment1
    @institution = Services::Institution.find(order1.giver_id)
  end

  describe 'when status is approved' do
    before do
      response_mercadopago = @pending_payment.gateway_data
      response_mercadopago["status"] = "approved"
      @response_mercadopago = response_mercadopago
    end

    it 'should update payment and update total_debt' do
      total_debt_init = @institution.calculated_total_debt
      Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(@pending_payment, @response_mercadopago)
      total_debt_final = @institution.calculated_total_debt
      total_debt_expect = total_debt_init - @pending_payment.amount

      expect(total_debt_final).to eql(total_debt_expect)
    end
  end

  describe 'when status is cancelled' do
    before do
      response_mercadopago = @pending_payment.gateway_data
      response_mercadopago["status"] = "cancelled"
      @response_mercadopago = response_mercadopago
    end

    it 'should not update payment and update total_debt' do
      total_debt_init = @institution.calculated_total_debt
      Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(@pending_payment, @response_mercadopago)
      total_debt_final = @institution.calculated_total_debt
      total_debt_expect = total_debt_init

      expect(total_debt_final).to eql(total_debt_expect)
    end
  end

  describe 'when status is pending' do
    before do
      response_mercadopago = @pending_payment.gateway_data
      response_mercadopago["status"] = "cancelled"
      @response_mercadopago = response_mercadopago
    end

    it 'should not update payment and update total_debt' do
      total_debt_init = @institution.calculated_total_debt
      Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(@pending_payment, @response_mercadopago)
      total_debt_final = @institution.calculated_total_debt
      total_debt_expect = total_debt_init

      expect(total_debt_final).to eql(total_debt_expect)
    end
  end

end