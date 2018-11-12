require 'rails_helper'

RSpec.describe AuthenticateUser do
  subject(:context) { described_class.call(email, password, ip) }

  let(:result) { context.result }
  let(:ip) { Faker::Internet.ip_v4_address }

  describe ".call" do
    let(:user) { create(:user_with_profile, password: 'password') }
    let(:email) { user.email }
    let(:password) { 'password' }

    context 'when the context is successful' do
      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:valid_token) { user.reload;JsonWebToken.encode({ user_id: user.id }, user.token_expire_at) }

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
