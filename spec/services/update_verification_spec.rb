require 'rails_helper'

RSpec.describe UpdateVerification do
  subject(:context) { described_class.call(verification, allowed_params, user) }

  let(:result) { context.result }
  let(:user) { create(:user_with_profile) }
  let(:vehicle) { create(:vehicle) }
  let(:verification) { create(:license_plate_verification, verificable: vehicle) }

  describe ".call" do

    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({
          type: "license_plate",
          information: {
            register_date: Faker::Date.between(5.years.ago, 1.year.ago),
            number: "#{Faker::Name.initials(3)}#{Faker::Number.number(3)}"
          }
        })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result.information[:number]).to eq(allowed_params[:information][:number]) }
        it { expect(result.information[:register_date]).to eq(allowed_params[:information][:register_date]) }
      end
    end

    context 'when the context is not successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ type: 'not_a_valid_type' })
      }

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
