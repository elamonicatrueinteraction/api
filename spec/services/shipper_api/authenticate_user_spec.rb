require 'rails_helper'

RSpec.describe ShipperApi::AuthenticateShipper do
  subject(:context) { described_class.call(email, password, ip) }

  let(:result) { context.result }
  let(:ip) { Faker::Internet.ip_v4_address }

  describe ".call" do
    let(:shipper) { create(:shipper_with_vehicle_and_bank_account, password: 'password') }
    let(:email) { shipper.email }
    let(:password) { 'password' }

    context 'when the context is successful' do
      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:valid_token) { shipper.reload;JsonWebToken.encode({ shipper_id: shipper.id }, shipper.token_expire_at) }

        before { context }

        it { expect(result).to eq(valid_token) }
        it { expect(result).to be_a(String) }
      end
    end

    context 'when the context is not successful' do
      let(:password) { 'invalid_password' }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
      end
    end
  end
end
