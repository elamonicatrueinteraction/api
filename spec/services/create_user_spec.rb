require 'rails_helper'

RSpec.describe CreateUser do
  subject(:context) { described_class.call(institution, allowed_params) }

  let(:result) { context.result }
  let(:institution) { create(:organization) }
  let(:profile) { build_stubbed(:profile) }
  let(:user) { profile.user }

  describe ".call" do
    let(:allowed_params) {
      HashWithIndifferentAccess.new({
        username: user.username,
        email: user.email,
        password: user.password,
        active: true,
        first_name: profile.first_name,
        last_name: profile.last_name,
        cellphone: Faker::PhoneNumber.cell_phone
      })
    }

    context 'when the context is successful' do
      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:created_user) { User.last }

        before { context }

        it { expect(result).to eq(created_user) }
        it { expect(result.institution).to eq(institution) }
      end
    end

    context 'when the context is not successful' do
      let(:allowed_params) {
        HashWithIndifferentAccess.new({
          username: user.username,
          email: nil,
          password: user.password,
          active: true,
          first_name: profile.first_name,
          last_name: profile.last_name,
          cellphone: Faker::PhoneNumber.cell_phone
        })
      }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(User.all).to be_empty }
      end
    end
  end
end
