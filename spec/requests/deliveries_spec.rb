require 'rails_helper'

RSpec.describe DeliveriesController, type: :request do
  include_context 'an authenticated user'
  let(:order) { create(:order) }
  let(:origin) { order.giver.addresses.first }
  let(:destination) { order.receiver.addresses.first }
  let(:order_id) { order.id }

  describe "GET #index" do
    let!(:delivery) { create(:delivery_with_packages, order: order) }

    context 'nested under orders path' do
      before { get "/orders/#{order_id}/deliveries", headers: auth_headers(user) }

      context 'with valid order_id data' do
        it_behaves_like 'a successful request', :deliveries
        it { expect(json[:deliveries].size).to eq(1) }
        it { expect(response).to match_response_schema("deliveries") }
      end

      context 'with invalid order_id data' do
        let(:order_id) { 'fake-id' }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "GET #show" do
    let!(:delivery) { create(:delivery_with_packages, order: order) }
    let(:delivery_id) { delivery.id }

    context 'nested under orders path' do
      before { get "/orders/#{order_id}/deliveries/#{delivery_id}", headers: auth_headers(user) }

      context 'with valid data' do
        it_behaves_like 'a successful request', :delivery
        it { expect(response).to match_response_schema("delivery") }
      end

      context 'with invalid order_id data' do
        let(:order_id) { 'fake-id' }

        it_behaves_like 'a not_found request'
      end

      context 'with invalid delivery_id data' do
        let(:delivery_id) { 'fake-id' }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "POST #create" do
    let(:delivery) { build_stubbed(:delivery) }
    let(:packages) { build_stubbed_list(:single_package, 3) }

    let(:delivery_parameters) {
      {
        origin_id: origin.id,
        destination_id: destination.id,
        amount: delivery.amount,
        bonified_amount: delivery.bonified_amount,
      }
    }
    let(:packages_parameters) {
      packages.map do |package|
        {
          quantity: package.quantity,
          weight: package.weight,
          volume: package.volume,
          fragile: package.fragile,
          cooling: package.cooling,
          description: package.description
        }
      end
    }

    context 'on absolute path' do
      before { post "/deliveries", headers: auth_headers(user), params: parameters }

      context 'without order_id' do
        let(:parameters) { delivery_parameters }

        it_behaves_like 'a bad_request request'
      end

      context 'with invalid order_id' do
        let(:parameters) { delivery_parameters.merge(order_id: 'fake-id') }

        it_behaves_like 'a not_found request'
      end

      context 'with valid order_id' do
        context 'with valid data' do
          context 'without packages' do
            let(:parameters) { delivery_parameters.merge(order_id: order_id) }

            it_behaves_like 'a successful create request', :delivery
            it { expect(response).to match_response_schema("delivery") }
          end

          context 'with packages' do
            let(:parameters) { delivery_parameters.merge(order_id: order_id, packages: packages_parameters) }

            it_behaves_like 'a successful create request', :delivery
            it { expect(response).to match_response_schema("delivery") }
          end
        end

        context 'with invalid data' do
          let(:parameters) { delivery_parameters.merge(order_id: order_id, origin_id: 'fake-id') }

          it_behaves_like 'a failed request'
        end
      end
    end
  end

  describe "PUT/PATCH #update" do
    let(:delivery) { create(:delivery_with_packages, order: order) }
    let(:delivery_id) { delivery.id }
    let(:delivery_update) { build_stubbed(:delivery) }
    let(:destination_update) { Address.all.sample }

    let(:delivery_parameters) {
      {
        destination_id: destination_update.id,
        amount: delivery_update.amount,
        bonified_amount: delivery_update.bonified_amount,
      }
    }

    context 'on absolute path' do
      before { patch "/deliveries/#{delivery_id}", headers: auth_headers(user), params: parameters }

      context 'without order_id' do
        let(:parameters) { delivery_parameters }

        it_behaves_like 'a bad_request request'
      end

      context 'with invalid order_id' do
        let(:parameters) { delivery_parameters.merge(order_id: 'fake-id') }

        it_behaves_like 'a not_found request'
      end

      context 'with valid order_id' do
        context 'with valid data' do
          let(:parameters) { delivery_parameters.merge(order_id: order_id) }

          it_behaves_like 'a successful request', :delivery
          it { expect(response).to match_response_schema("delivery") }
        end

        context 'with invalid data' do
          let(:parameters) { delivery_parameters.merge(order_id: order_id, destination_id: 'fake-id') }

          it_behaves_like 'a failed request'
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let(:delivery) { create(:delivery_with_packages, order: order) }
    let(:delivery_id) { delivery.id }

    context 'nested under orders path' do
      before { delete "/orders/#{order_id}/deliveries/#{delivery_id}", headers: auth_headers(user) }

      context 'with valid delivery_id' do
        it_behaves_like 'a successful request', :delivery
        it { expect(response).to match_response_schema("delivery_id") }
      end

      context 'with invalid delivery_id' do
        let(:delivery_id) { 'fake-id' }

        it_behaves_like 'a not_found request'
      end

      context 'with invalid order_id' do
        let(:order_id) { 'fake-id' }

        it_behaves_like 'a not_found request'
      end
    end

    context 'on absolute path' do
      before { delete "/deliveries/#{delivery_id}", headers: auth_headers(user), params: parameters }

      context 'without order_id' do
        let(:parameters) { {} }
        it_behaves_like 'a bad_request request'
      end

      context 'with invalid order_id' do
        let(:parameters) { { order_id: 'fake-id' } }

        it_behaves_like 'a not_found request'
      end

      context 'with valid order_id' do
        let(:parameters) { { order_id: order_id } }

        it_behaves_like 'a successful request', :delivery
        it { expect(response).to match_response_schema("delivery_id") }
      end
    end
  end
end
