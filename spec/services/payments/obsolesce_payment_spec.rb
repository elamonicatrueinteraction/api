require 'rails_helper'
require 'helpers/gateway_helpers'

describe 'Obsolesce Payment' do

  before do
    Scheduler::Provider.configure do |config|
      config.logistic_scheduler = Scheduler::FakeScheduler.new
    end
  end



  context 'when payment is paid' do
    let!(:order) { create(:order, network_id: "MDQ") }
    let!(:payment) { create(:approved_payment, network_id: "MDQ", payable: order) }
    let!(:action) { Payments::ObsolescePayment.new }
    it 'returns error' do
      action.obsolesce(payment: payment, institution: nil)
      errors = action.errors
      expect(errors.length).to be(1)
    end
  end

  context "when payment's remote correspondence has been paid" do
    let!(:order) { create(:order, network_id: "MDQ") }
    let!(:payment) { create(:payment, network_id: "MDQ", payable: order) }
    let!(:gateway_mock) { GatewayHelpers::AlwaysPaidGateway.new}
    let!(:provider) { GatewayHelpers::FakePaymentGateway.new(gateway_mock) }
    let!(:action) { Payments::ObsolescePayment.new(account_provider: provider) }

    it 'returns error' do
      action.obsolesce(payment: payment, institution: nil)
      errors = action.errors
      expect(errors.length).to be(1)
      expect(gateway_mock.times_called).to be(1)
    end
  end
end