require 'rails_helper'

RSpec.describe CreateAddress do
  subject(:context) { described_class.call(institution, allowed_params) }

  let(:result) { context.result }
  let(:institution) { create(:organization) }

  describe ".call" do
    let(:allowed_params) {
      HashWithIndifferentAccess.new({ latlng: "#{Faker::Address.latitude},#{Faker::Address.longitude}" })
    }

    context 'when the context is successful' do
      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:address) { Address.last }

        before { context }

        it { expect(result).to eq(address) }
        it { expect(result.institution).to eq(institution) }
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
        it { expect(Address.all).to be_empty }
      end
    end
  end
end
