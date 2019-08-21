require 'rails_helper'

RSpec.describe Gateway::PaymentsCheck do

  describe 'request check all payments' do

    let!(:order) { create(:order) }
    let!(:cancelled_payment) { create(:payment, payable: order, status: Payment::Types::CANCELLED) }
    let!(:pending_payment) { CreatePayment.call() }
    let!(:another_pending_payment) { create(:payment, payable: order) }
    let!(:institution) { Services::Institution.find(order.giver_id) }

    it 'should update only payment with state approved' do
      total_debt_init = institution.calculated_total_debt
      payment_check = Gateway::PaymentsCheck.new
      payment_check.check_payments
      total_debt_final = institution.calculated_total_debt
      total_debt_expect = total_debt_init - (pending_payment.amount + another_pending_payment.amount)

      expect(total_debt_final).to eql(total_debt_expect)
      expect(Payment.find(pending_payment.id).status).to eql(Payment::Types::APPROVED)
      expect(Payment.find(another_pending_payment.id).status).to eql(Payment::Types::APPROVED)
      expect(Payment.find(cancelled_payment.id).status).to eql(Payment::Types::CANCELLED)
    end

  end

end