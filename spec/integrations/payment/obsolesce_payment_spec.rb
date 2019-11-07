require 'rails_helper'
require 'helpers/meli_helpers'

describe 'MercadoPago Obsolesce Payment', type: :request do
  include_context 'an authenticated user'

  let(:debt_calculator) { Payments::TotalDebt.new }
  let!(:institution) {
    institution = OpenStruct.new
    institution.id = '37d4970a-53ea-49f5-a2f1-2cdf26f36454'
    institution
  }
  let!(:order) {
    create(:order, amount: 200, bonified_amount: 0, receiver_id: institution.id, network_id: "MDQ")
  }
  let!(:token) { Rails.application.secrets.job_token }
  let!(:scheduler) { Scheduler::FakeScheduler.new }
  let(:meli_test_client_secret) { Rails.application.secrets.mercadopago_bar_access_token }
  let(:meli_client) { Gateway::Mercadopago::MercadopagoClient.new(meli_test_client_secret) }

  before do
    Scheduler::Provider.configure do |config|
      config.logistic_scheduler = scheduler
    end
    unless MeliHelpers.mercadopago_test_credentials?("TEST-asd", meli_test_client_secret)
      raise 'Meli production tokens are being used'
    end
  end

  context 'when payment uses Mercadopago' do

    before do
      AccountBalance.destroy_all
      Payment.destroy_all
      CreatePayment.call(payable: order, amount: order.amount, payment_type: Payment::PaymentTypes::PAGOFACIL)
    end

    it 'obsolesces payment' do
      payment = Payment.first
      accountBalance = AccountBalance.where(institution_id: institution.id).first || AccountBalance.new(institution_id: institution.id, amount: 0)
      expect(accountBalance.amount).to eq(order.total_amount)
      put "/payments/obsolesce/#{payment.id}", headers: { Authorization: 'Token asd', 'X-Network-Id': "MDQ" }
      expect(response).to have_http_status(:ok)
      accountBalance = AccountBalance.where(institution_id: institution.id).first || AccountBalance.new(institution_id: institution.id, amount: 0)
      expect(accountBalance.amount).to eq(0)
      payment.reload
      expect(payment.status).to eq(Payment::Types::OBSOLETE)
      expect(scheduler.times).to eq(1)
    end
  end

  after do
    payment = Payment.first
    meli_client.cancel_payment(payment.gateway_id) unless payment.nil?
  end
end
