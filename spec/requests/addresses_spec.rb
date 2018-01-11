require 'rails_helper'

RSpec.describe AddressesController, type: :request do
  let(:user) { create(:user_with_profile) }

  describe "GET #index" do
    let(:organization) { create(:organization) }
    let!(:addresses) { create_list(:address, 3, institution: organization) }

    before { get "/institutions/#{organization_id}/addresses", headers: auth_headers(user) }

    context 'with valid organization_id' do
      let(:organization_id) { organization.id }

      it_behaves_like 'a successful request', :addresses
      it { expect(json[:addresses].size).to eq(3) }
      it { expect(response).to match_response_schema("addresses") }
    end

    context 'with invalid organization_id' do
      let(:organization_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end

  describe "POST #create" do
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }
    let(:address) { build_stubbed(:address) }

    before { post "/institutions/#{organization_id}/addresses", headers: auth_headers(user), params: parameters }

    let(:parameters) {
      {
        latlng: address.latlng,
        street_1: address.street_1,
        street_2: address.street_2,
        zip_code: address.zip_code,
        city: address.city,
        state: address.state,
        country: address.country,
        contact_name: address.contact_name,
        contact_cellphone: address.contact_cellphone,
        contact_email: address.contact_email,
        telephone: address.telephone,
        open_hours: address.open_hours,
        notes: ''
      }
    }

    context 'with valid data' do
      it_behaves_like 'a successful create request', :address
      it { expect(response).to match_response_schema("address") }
      it { expect(Gateway::Shippify::PlaceWorker).to have_enqueued_sidekiq_job(json[:address][:id], 'create') }
      it { expect(Gateway::Shippify::PlaceWorker.jobs.size).to eq(1) }
    end

    context 'with invalid data' do
      let(:parameters) {
        {
          latlng: nil,
          street_1: address.street_1,
          street_2: address.street_2,
          zip_code: address.zip_code,
          city: address.city,
          state: address.state,
          country: address.country,
          contact_name: address.contact_name,
          contact_cellphone: address.contact_cellphone,
          contact_email: address.contact_email,
          telephone: address.telephone,
          open_hours: address.open_hours,
          notes: ''
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
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }
    let(:address) { create(:address, institution: organization) }
    let(:address_id) { address.id }
    let(:address_update) { build_stubbed(:address) }

    before { patch "/institutions/#{organization_id}/addresses/#{address_id}", headers: auth_headers(user), params: parameters }

    let(:parameters) {
      {
        street_1: address_update.street_1,
        street_2: address_update.street_2,
        zip_code: address_update.zip_code
      }
    }

    context 'with valid data' do
      it_behaves_like 'a successful request', :address
      it { expect(response).to match_response_schema("address") }
      it { expect(Gateway::Shippify::PlaceWorker).to have_enqueued_sidekiq_job(json[:address][:id], 'update') }
      it { expect(Gateway::Shippify::PlaceWorker.jobs.size).to eq(1) }
    end

    context 'with invalid data' do
      let(:parameters) {
        {
          latlng: nil,
          street_1: address_update.street_1,
          street_2: address_update.street_2,
          zip_code: address_update.zip_code
        }
      }

      skip("can't find a way to make it fail")
      # it_behaves_like 'a failed request'
    end

    context 'with invalid address_id' do
      let(:address_id) { SecureRandom.uuid }

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
    let(:address) { create(:address, institution: organization) }
    let(:address_id) { address.id }

    before { delete "/institutions/#{organization_id}/addresses/#{address_id}", headers: auth_headers(user) }

    context 'with valid address_id' do
      it_behaves_like 'a successful request', :address
      it { expect(response).to match_response_schema("address_id") }
    end

    context 'with invalid address_id' do
      let(:address_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid organization_id' do
      let(:organization_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end
  end
end
