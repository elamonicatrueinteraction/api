require 'rails_helper'

RSpec.describe AuthorizeRequest do
  subject(:context) { described_class.call(headers) }

  let(:result) { context.result }

  describe ".call" do
    let(:user) { create(:authenticated_user) }
    let(:headers) { { 'Authorization' => "Token #{auth_token}" } }

    context 'when the context is successful' do
      let(:auth_token) { JsonWebToken.encode({ user_id: user.id }, user.token_expire_at) }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result).to eq(user.reload) }
        it { expect(result).to be_a(User) }
      end
    end

    context 'when the context is not successful' do
      let(:fake_user_id) { SecureRandom.uuid }
      let(:auth_token) { JsonWebToken.encode({ user_id: fake_user_id }, 24.hours.from_now.to_i) }

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
