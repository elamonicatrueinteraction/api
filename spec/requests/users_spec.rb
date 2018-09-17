require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:logged_user) { create(:user_with_profile) }

  describe "GET #index" do
    let(:organization) { create(:organization_with_users) }

    before { get "/institutions/#{organization_id}/users", headers: auth_headers(logged_user) }

    context 'with valid organization_id' do
      let(:organization_id) { organization.id }

      it_behaves_like 'a successful request', :users
      it { expect(json[:users]).not_to be_empty }
      it { expect(response).to match_response_schema("users") }
    end

    context 'with invalid organization_id' do
      let(:organization_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "POST #create" do
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }
    let(:profile) { build_stubbed(:profile) }
    let(:user) { profile.user }

    before { post "/institutions/#{organization_id}/users", headers: auth_headers(logged_user), params: parameters }

    let(:parameters) {
      {
        username: user.username,
        email: user.email,
        password: user.password,
        active: true,
        first_name: profile.first_name,
        last_name: profile.last_name,
        cellphone: Faker::PhoneNumber.cell_phone
      }
    }

    context 'with valid data' do
      it_behaves_like 'a successful create request', :user
      it { expect(response).to match_response_schema("user") }
    end

    context 'with invalid data' do
      let(:parameters) {
        {
          username: user.username,
          email: user.email,
          active: true,
          first_name: profile.first_name,
          last_name: profile.last_name,
          cellphone: Faker::PhoneNumber.cell_phone
        }
      }

      it_behaves_like 'a failed request'
    end

    context 'with invalid organization_id' do
      let(:organization_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "PUT/PATCH #update" do
    let(:organization) { create(:organization_with_users) }
    let(:organization_id) { organization.id }
    let(:user) { organization.users.sample }
    let(:user_id) { user.id }
    let(:profile_update) { build_stubbed(:profile) }
    let(:user_update) { profile_update.user }

    before { patch "/institutions/#{organization_id}/users/#{user_id}", headers: auth_headers(logged_user), params: parameters }

    let(:parameters) {
      {
        email: user_update.email,
        active: false,
        cellphone: Faker::PhoneNumber.cell_phone
      }
    }

    context 'with valid data' do
      it_behaves_like 'a successful request', :user
      it { expect(response).to match_response_schema("user") }
    end

    context 'with invalid data' do
      let(:parameters) {
        {
          email: nil,
          active: false,
          cellphone: nil
        }
      }

      it_behaves_like 'a failed request'
    end

    context 'with invalid user_id' do
      let(:user_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid organization_id' do
      let(:organization_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "DELETE #destroy" do
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }
    let(:user) { create(:user, institution: organization) }
    let(:user_id) { user.id }

    before { delete "/institutions/#{organization_id}/users/#{user_id}", headers: auth_headers(logged_user) }

    context 'with valid user_id' do
      it_behaves_like 'a successful request', :user
      it { expect(response).to match_response_schema("user_id") }
    end

    context 'with invalid user_id' do
      let(:user_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid organization_id' do
      let(:organization_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end
end
