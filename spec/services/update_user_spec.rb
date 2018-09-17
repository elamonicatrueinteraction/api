require 'rails_helper'

RSpec.describe UpdateUser do
  subject(:context) { described_class.call(user, allowed_params) }

  let(:result) { context.result }
  let(:user) { create(:organization_user) }

  let(:stubbed_profile) { build_stubbed(:profile) }
  let(:stubbed_user) { stubbed_profile.user }

  describe ".call" do

    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({
          first_name: stubbed_profile.first_name,
          email: stubbed_user.email
        })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result.email).to eq(stubbed_user.email) }
        it { expect(result.profile.first_name).to eq(stubbed_profile.first_name) }
      end
    end

    context 'when the context is not successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({
          first_name: stubbed_profile.first_name,
          email: nil
        })
      }

      it 'fails' do
        expect(context).to be_failure
      end
    end
  end
end
