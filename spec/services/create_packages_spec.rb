require 'rails_helper'

RSpec.describe CreatePackages do
  subject(:context) { described_class.call(delivery, allowed_params, within_transaction) }

  let(:result) { context.result }
  let(:delivery) { create(:delivery) }
  let(:packages_params) {
    HashWithIndifferentAccess.new({
      packages: attributes_for_list(:single_package, 2)
    })
  }
  let(:allowed_params) { packages_params[:packages] }

  describe ".call separetly" do
    let(:within_transaction) { false }

    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:packages) { Package.all }

        before { context }

        it { expect(result).to eq(packages) }
        it { expect(result).to all(be_a(Package)) }
      end
    end

    context 'when the context is not successful' do
      let(:delivery) { nil }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Package.all).to be_empty }
      end
    end
  end

  describe ".call within transaction" do
    let(:within_transaction) { true }

    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:packages) { Package.all }

        before { context }

        xit { expect(result).to eq(packages) }
        it { expect(result).to all(be_a(Package)) }
      end
    end

    xcontext 'when the context is not successful' do
      let(:delivery) { nil }

      it 'raise error' do
        expect{ context }.to raise_error(Service::Error)
      end
      it { expect(Package.all).to be_empty }
    end
  end
end
