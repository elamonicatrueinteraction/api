require 'rails_helper'

RSpec.describe CreateVerification do
  include_context 'an authenticated user'
  subject(:context) { described_class.call(verificable, allowed_params, user) }

  let(:result) { context.result }

  let(:vehicle) { create(:vehicle) }
  let(:verified) { Faker::Boolean.boolean }

  let(:allowed_params) { HashWithIndifferentAccess.new(attributes_for(:license_plate_verification).merge(verified: verified)) }

  context 'verificable is a vehicle' do
    let(:verificable) { vehicle }

    describe ".call " do
      context 'when the context is successful' do
        it 'succeeds' do
          expect(context).to be_success
        end

        describe 'valid result' do
          let(:verification) { Verification.last }

          before { context }

          it { expect(result).to eq(verification) }
          it { expect(result.verificable).to eq(vehicle) }
          it 'matching verification params' do
            expect(result.expire).to eq(allowed_params[:expire])
            expect(result.expire_at).to eq(allowed_params[:expire_at])
            expect(result.verified?).to eq(verified)
            if verified
              expect(result.responsible).to eq(user)
            end
          end
        end
      end

      context 'when the context is not successful' do
        let(:allowed_params) { {} }

        it 'fails' do
          expect(context).to be_failure
        end

        describe 'result is nil' do
          before { context }

          it { expect(result).to be_nil }
          it { expect(Verification.all).to be_empty }
        end
      end
    end
  end
end
