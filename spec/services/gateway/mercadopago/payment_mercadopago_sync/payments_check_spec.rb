require 'rails_helper'

RSpec.describe Gateway::Mercadopago::PaymentMercadopagoSync::PaymentsCheck do

  describe 'request check all payments' do

    before do
      order1 = create(:order)
      @payment1 = create(:payment, payable_id: order1.id)
      @payment2 = create(:payment, payable_id: order1.id)
      @payment3 = create(:payment, payable_id: order1.id)
      @payment3.status = "cancelled"

      @payment1.save
      @payment2.save
      @payment3.save

      @institution = Services::Institution.find(order1.giver_id)
    end

    it 'should update only payment with state approved' do
      total_debt_init = @institution.calculated_total_debt
      Gateway::Mercadopago::PaymentMercadopagoSync::PaymentsCheck.call
      total_debt_final = @institution.calculated_total_debt
      total_debt_expect = total_debt_init - (@payment1.amount + @payment2.amount)

      expect(total_debt_final).to eql(total_debt_expect)
      expect(Payment.find_by(:id => @payment1.id)["status"]).to eql("approved")
      expect(Payment.find_by(:id => @payment2.id)["status"]).to eql("approved")
      expect(Payment.find_by(:id => @payment3.id)["status"]).to eql("cancelled")
    end

  end

end