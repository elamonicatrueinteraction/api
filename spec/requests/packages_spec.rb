require 'rails_helper'

RSpec.describe PackagesController, type: :request do
  include_context 'an authenticated user'
  let(:delivery) { create(:delivery) }
  let(:delivery_id) { delivery.id }

  describe "GET #index" do
    let!(:packages) { create_list(:package, 5, delivery: delivery) }

    before { get "/deliveries/#{delivery_id}/packages", headers: auth_headers(user) }

    context 'with valid delivery_id data' do
      it_behaves_like 'a successful request', :packages
      it { expect(json[:packages].size).to eq(5) }
      it { expect(response).to match_response_schema("packages") }
    end

    context 'with invalid delivery_id data' do
      let(:delivery_id) { 'fake-id' }

      it_behaves_like 'a not_found request'
    end
  end

  describe "GET #show" do
    let!(:package) { create(:package, delivery: delivery) }
    let(:package_id) { package.id }

    before { get "/deliveries/#{delivery_id}/packages/#{package_id}", headers: auth_headers(user) }

    context 'with valid data' do
      it_behaves_like 'a successful request', :package
      it { expect(response).to match_response_schema("package") }
    end

    context 'with invalid delivery_id data' do
      let(:delivery_id) { 'fake-id' }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid package_id data' do
      let(:package_id) { 'fake-id' }

      it_behaves_like 'a not_found request'
    end
  end

  describe "POST #create" do
    let(:package) { build_stubbed(:package) }

    let(:packages_parameters) {
      {
        packages: [{
          quantity: package.quantity,
          weight: package.weight,
          volume: package.volume,
          fragile: package.fragile,
          cooling: package.cooling,
          description: package.description
        }]
      }
    }
    let(:parameters) { packages_parameters }

    before { post "/deliveries/#{delivery_id}/packages", headers: auth_headers(user), params: parameters }

    context 'with valid package data' do
      it { expect(Package.count).to eq(1) }
      it_behaves_like 'a successful create request', :packages
      it { expect(response).to match_response_schema("packages") }
    end

    context 'with invalid delivery_id data' do
      let(:delivery_id) { 'fake-id' }

      it { expect(Package.count).to eq(0) }
      it_behaves_like 'a not_found request'
    end
  end

  describe "PUT/PATCH #update" do
    let(:package) { create(:package, delivery: delivery) }
    let(:package_id) { package.id }
    let(:package_update) { build_stubbed(:package) }

    let(:package_parameters) {
      {
        quantity: package_update.quantity,
        weight: package_update.weight,
        volume: package_update.volume,
        fragile: package_update.fragile,
        cooling: package_update.cooling,
        description: package_update.description
      }
    }
    let(:parameters) { package_parameters }

    before { patch "/deliveries/#{delivery_id}/packages/#{package_id}", headers: auth_headers(user), params: parameters }

    context 'with valid data' do
      it_behaves_like 'a successful request', :package
      it { expect(response).to match_response_schema("package") }
    end

    context 'with invalid package id' do
      let(:package_id) { 'fake-id' }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid delivery id' do
      let(:delivery_id) { 'fake-id' }

      it_behaves_like 'a not_found request'
    end
  end

  describe "DELETE #destroy" do
    let(:package) { create(:package, delivery: delivery) }
    let(:package_id) { package.id }

    before { delete "/deliveries/#{delivery_id}/packages/#{package_id}", headers: auth_headers(user) }

    context 'with valid data' do
      it_behaves_like 'a successful request', :package
      it { expect(Package.all).to be_blank }
      it { expect(response).to match_response_schema("package_id") }
    end

    context 'with invalid package id' do
      let(:package_id) { 'fake-id' }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid delivery id' do
      let(:delivery_id) { 'fake-id' }

      it { expect(Package.count).to eq(1) }
      it_behaves_like 'a not_found request'
    end
  end
end
