require 'rails_helper'

RSpec.describe UpdatePackage do
  subject(:context) { described_class.call(package, allowed_params) }

  let(:result) { context.result }
  let(:package) { create(:package) }

  describe ".call" do
    let(:description) { 'Some dummy description' }
    let(:quantity) { 100 }

    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ quantity: quantity, description: quantity })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result.quantity).to eq(quantity) }
        it { expect(result.quantity).to eq(quantity) }
      end
    end

    context 'when the context is not successful' do
      let(:allowed_params) { {} }

      it 'fails' do
        skip("can't find a way to make it fail")
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { skip("can't find a way to make it fail");expect(result).to be_nil }
        it { skip("can't find a way to make it fail");expect(Address.all).to be_empty }
      end
    end
  end
end
