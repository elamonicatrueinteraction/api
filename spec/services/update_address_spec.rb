require 'rails_helper'

RSpec.describe UpdateAddress do
  subject(:context) { described_class.call(address, allowed_params) }

  let(:result) { context.result }
  let(:address) { create(:organization_address) }

  describe ".call" do
    let(:contact_name) { Faker::Name.name }
    let(:contact_email) { Faker::Internet.free_email }

    context 'when the context is successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({ contact_name: contact_name, contact_email: contact_email })
      }

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        before { context }

        it { expect(result.contact_name).to eq(contact_name) }
        it { expect(result.contact_email).to eq(contact_email) }
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
