require 'rails_helper'

RSpec.describe BankAccountsController, type: :request do
  let(:user) { create(:user_with_profile) }
  let(:shipper) { create(:shipper) }
  let(:shipper_id) { shipper.id }

  describe "GET #index" do
    let!(:bank_account) { create_list(:bank_account, 2, shipper: shipper) }

    context 'nested under shippers path' do
      before { get "/shippers/#{shipper_id}/bank_accounts", headers: auth_headers(user) }

      context 'with valid shipper_id data' do
        it_behaves_like 'a successful request', :bank_accounts
        it { expect(json[:bank_accounts].size).to eq(2) }
        it { expect(response).to match_response_schema("bank_accounts") }
      end

      context 'with invalid shipper_id data' do
        let(:shipper_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "GET #show" do
    let!(:bank_account) { create(:bank_account, shipper: shipper) }
    let(:bank_account_id) { bank_account.id }

    context 'nested under shippers path' do
      before { get "/shippers/#{shipper_id}/bank_accounts/#{bank_account_id}", headers: auth_headers(user) }

      context 'with valid data' do
        it_behaves_like 'a successful request', :bank_account
        it { expect(response).to match_response_schema("bank_account") }
      end

      context 'with invalid shipper_id data' do
        let(:shipper_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end

      context 'with invalid bank_account_id data' do
        let(:bank_account_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end

    context 'on absolute path' do
      before { get "/bank_accounts/#{bank_account_id}", headers: auth_headers(user) }

      context 'with valid data' do
        it_behaves_like 'a successful request', :bank_account
        it { expect(response).to match_response_schema("bank_account") }
      end

      context 'with invalid bank_account_id data' do
        let(:bank_account_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "POST #create" do
    let(:bank_account) { build_stubbed(:bank_account) }
    let(:shipper_id) { shipper.id }

    let(:bank_account_parameters) {
      {
        bank_name: bank_account.bank_name,
        number: bank_account.number,
        type: bank_account.type,
        cbu: bank_account.cbu
      }
    }
    let(:parameters) { bank_account_parameters }

    context 'nested under shippers path' do
      before { post "/shippers/#{shipper_id}/bank_accounts", headers: auth_headers(user), params: parameters }

      context 'with valid data' do
        it_behaves_like 'a successful create request', :bank_account
        it { expect(response).to match_response_schema("bank_account") }
      end

      context 'with invalid data' do
        let(:parameters) { bank_account_parameters.except(:bank_name, :number) }

        it_behaves_like 'a failed request'
      end
    end

    context 'on absolute path' do
      before { post "/bank_accounts", headers: auth_headers(user), params: parameters }

      context 'without shipper_id' do
        it_behaves_like 'a bad_request request'
      end

      context 'with invalid shipper_id' do
        let(:parameters) { bank_account_parameters.merge(shipper_id: SecureRandom.uuid) }

        it_behaves_like 'a not_found request'
      end

      context 'with valid shipper_id data' do

        context 'with valid data' do
          let(:parameters) { bank_account_parameters.merge(shipper_id: shipper_id) }

          it_behaves_like 'a successful create request', :bank_account
          it { expect(response).to match_response_schema("bank_account") }
        end

        context 'with invalid data' do
          let(:parameters) { bank_account_parameters.merge(shipper_id: shipper_id).except(:bank_name, :number) }

          it_behaves_like 'a failed request'
        end
      end
    end
  end

  describe "PUT/PATCH #update" do
    let(:bank_account) { create(:bank_account, shipper: shipper) }
    let(:shipper_id) { shipper.id }
    let(:bank_account_id) { bank_account.id }
    let(:bank_account_update) { build_stubbed(:bank_account) }

    let(:bank_account_parameters) {
      {
        bank_name: bank_account_update.bank_name,
        number: bank_account_update.number,
        type: bank_account_update.type,
        cbu: bank_account_update.cbu
      }
    }
    let(:parameters) { bank_account_parameters }

    context 'nested under shippers path' do
      before { patch "/shippers/#{shipper_id}/bank_accounts/#{bank_account_id}", headers: auth_headers(user), params: parameters }

      context 'with valid data' do
        it_behaves_like 'a successful request', :bank_account
        it { expect(response).to match_response_schema("bank_account") }
      end

      context 'with invalid data' do
        let(:parameters) { bank_account_parameters.merge(bank_name: '') }

        it_behaves_like 'a failed request'
      end

      context 'with invalid bank account id' do
        let(:bank_account_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end

      context 'with invalid shipper id' do
        let(:shipper_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end

    context 'on absolute path' do
      before { patch "/bank_accounts/#{bank_account_id}", headers: auth_headers(user), params: parameters }

      context 'with shipper_id data' do
        context 'with valid data' do
          let(:parameters) { bank_account_parameters.merge(shipper_id: shipper_id) }

          it_behaves_like 'a successful request', :bank_account
          it { expect(response).to match_response_schema("bank_account") }
        end

        context 'with invalid data' do
          let(:parameters) { bank_account_parameters.merge(bank_name: '', shipper_id: shipper_id) }

          it_behaves_like 'a failed request'
        end

        context 'with invalid bank account id' do
          let(:bank_account_id) { SecureRandom.uuid }
          let(:parameters) { bank_account_parameters.merge(shipper_id: shipper_id) }

          it_behaves_like 'a not_found request'
        end

        context 'with invalid shipper id' do
          let(:parameters) { bank_account_parameters.merge(shipper_id: SecureRandom.uuid) }

          it_behaves_like 'a not_found request'
        end
      end

      context 'without shipper_id data' do
        context 'with valid data' do
          it_behaves_like 'a successful request', :bank_account
          it { expect(response).to match_response_schema("bank_account") }
        end

        context 'with invalid data' do
          let(:parameters) { bank_account_parameters.merge(bank_name: '') }

          it_behaves_like 'a failed request'
        end

        context 'with invalid bank account id' do
          let(:bank_account_id) { SecureRandom.uuid }

          it_behaves_like 'a not_found request'
        end
      end
    end
  end
end
