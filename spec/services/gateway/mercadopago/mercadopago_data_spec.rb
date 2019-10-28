require 'rails_helper'

describe 'Mercadopago Data Access' do

  let!(:paid_request_json) { JSON.parse(File.read("spec/fixtures/paid_mercadopago_response.json")) }
  let!(:created_request_json) { JSON.parse(File.read("spec/fixtures/created_mercadopago_response.json")) }
  let!(:bad_request_json) { JSON.parse(File.read("spec/fixtures/bad_request_mercadopago_response.json")) }
  let!(:expired_json) { JSON.parse(File.read("spec/fixtures/expired_mercadopago_response.json")) }

  context 'with paid mercadopago request' do
    let!(:data) { Gateway::Mercadopago::Data.new(paid_request_json) }

    it { expect(data.status).to_not be_nil }
    it { expect(data.payment_id).to_not be_nil }
    it { expect(data.paid_at).to_not be_nil }
    it { expect(data.gateway).to_not be_nil }
    it { expect(data.total_paid_amount).to_not be_nil }
    it { expect(data.total_fees).to_not be_nil }
    it { expect(data.raw_data).to_not be_nil }
  end

  context 'with expired mercadopago request' do
    let!(:data) { Gateway::Mercadopago::Data.new(expired_json) }

    it { expect(data.status).to eq "pending" }
    it { expect(data.payment_id).to_not be_nil }
    it { expect(data.paid_at).to be_nil }
    it { expect(data.gateway).to_not be_nil }
    it { expect(data.total_paid_amount).to_not be_nil }
    it { expect(data.total_fees).to_not be_nil }
    it { expect(data.raw_data).to_not be_nil }
  end

  context 'with created mercadopago request' do
    let!(:data) { Gateway::Mercadopago::Data.new(created_request_json) }

    it { expect(data.status).to_not be_nil }
    it { expect(data.payment_id).to_not be_nil }
    it { expect(data.paid_at).to be_nil }
    it { expect(data.gateway).to_not be_nil }
    it { expect(data.total_paid_amount).to_not be_nil }
    it { expect(data.total_fees).to_not be_nil }
    it { expect(data.raw_data).to_not be_nil }
  end

  context 'with bad mercadopago request' do
    let!(:data) { Gateway::Mercadopago::Data.new(bad_request_json) }

    it { expect(data.status).to eq("400") }
    it { expect(data.payment_id).to be_nil }
    it { expect(data.paid_at).to be_nil }
    it { expect(data.gateway).to_not be_nil }
    it { expect(data.total_paid_amount).to be_nil }
    it { expect(data.total_fees).to be_nil }
    it { expect(data.raw_data).to_not be_nil }
  end
end