require 'rails_helper'

RSpec.describe OrdersController, type: :request do
  let(:user) { create(:user_with_profile) }
  let(:giver) { create(:company_with_address) }
  let(:receiver) { create(:organization_with_address) }

  describe "GET #index" do
    let!(:orders) { create_list(:full_order, 3) }

    context 'direct orders path' do
      before { get '/orders', headers: auth_headers(user) }

      it_behaves_like 'a successful request', :orders
      it { expect(json[:orders].size).to eq(3) }
      it { expect(response).to match_response_schema("orders") }
    end

    context 'nested under institutions path' do
      let(:institution_id) { orders.sample.receiver_id }

      before { get "/institutions/#{institution_id}/orders", headers: auth_headers(user) }

      context 'with valid institution_id data' do
        it_behaves_like 'a successful request', :orders
        it { expect(json[:orders].size).to eq(1) }
        it { expect(response).to match_response_schema("orders") }
      end

      context 'with invalid institution_id data' do
        let(:institution_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "GET #show" do
    let(:order) { create(:full_order) }
    before { get "/orders/#{order.id}", headers: auth_headers(user) }

    it_behaves_like 'a successful request', :order
    it { expect(response).to match_response_schema("order") }
  end

  describe "POST #create" do
    let(:order) { build_stubbed(:order) }
    let(:delivery) { build_stubbed(:delivery) }
    let(:packages) { build_stubbed_list(:single_package, 3) }
    let(:origin_id) { giver.addresses.first.id }
    let(:destination_id) { receiver.addresses.first.id }

    let(:order_parameters) {
      {
        giver_id: giver.id,
        receiver_id: receiver.id,
        expiration: order.expiration,
        amount: order.amount,
        bonified_amount: order.bonified_amount
      }
    }
    let(:delivery_parameters){
      {
        origin_id: origin_id,
        destination_id: destination_id,
        delivery_amount: delivery.amount,
        delivery_bonified_amount: delivery.bonified_amount,
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

    before { post '/orders', headers: auth_headers(user), params: parameters }

    context 'only order data' do
      context 'with valid data' do
        let(:parameters) { order_parameters }

        it_behaves_like 'a successful create request', :order
        it { expect(Order.count).to eq(1) }
        it { expect(Delivery.all).to be_blank }
        it { expect(Package.all).to be_blank }
        it { expect(response).to match_response_schema("order") }
      end

      context 'with invalid data' do
        let(:parameters) { order_parameters.merge(giver_id:  SecureRandom.uuid) }

        it_behaves_like 'a failed request'
        it { expect(Order.all).to be_blank }
        it { expect(Delivery.all).to be_blank }
        it { expect(Package.all).to be_blank }
      end
    end

    context 'with delivery data' do
      context 'with valid data' do
        let(:parameters) { order_parameters.merge(delivery_parameters) }

        it_behaves_like 'a successful create request', :order
        it { expect(Order.count).to eq(1) }
        it { expect(Delivery.count).to eq(1) }
        it { expect(Package.all).to be_blank }
        it { expect(response).to match_response_schema("order") }
      end

      context 'with invalid data' do
        let(:parameters) { order_parameters.merge(delivery_parameters).merge(origin_id:  SecureRandom.uuid) }

        it_behaves_like 'a failed request'
        it { expect(Order.all).to be_blank }
        it { expect(Delivery.all).to be_blank }
        it { expect(Package.all).to be_blank }
      end
    end

    context 'with delivery and packages data' do
      context 'with valid data' do
        let(:parameters) { order_parameters.merge(delivery_parameters).merge(packages: packages_parameters) }

        it_behaves_like 'a successful create request', :order
        it { expect(Order.count).to eq(1) }
        it { expect(Delivery.count).to eq(1) }
        it { expect(Package.count).to eq(3) }
        it { expect(response).to match_response_schema("order") }
      end

      context 'with invalid data' do
        let(:parameters) { order_parameters.merge(delivery_parameters).merge(origin_id:  SecureRandom.uuid).merge(packages: packages_parameters) }

        it_behaves_like 'a failed request'
        it { expect(Order.all).to be_blank }
        it { expect(Delivery.all).to be_blank }
        it { expect(Package.all).to be_blank }
      end
    end
  end

  describe "DELETE #destroy" do
    let(:order) { create(:full_order) }
    let(:order_id) { order.id }

    before { delete "/orders/#{order_id}", headers: auth_headers(user) }

    context 'with valid order_id' do
      it_behaves_like 'a successful request', :order
      it { expect(Order.all).to be_blank }
      it { expect(Delivery.all).to be_blank }
      it { expect(Package.all).to be_blank }
      it { expect(response).to match_response_schema("order_id") }
    end

    context 'with invalid order_id' do
      let(:order_id) { SecureRandom.uuid }

      it_behaves_like 'a not_found request'
    end

    context 'with invalid conditions' do
      let(:trip) { create(:trip) }
      let(:order) { trip.deliveries.first.order }

      it { expect(Order.count).to eq(1) }
      it_behaves_like 'a failed request'
    end
  end
end
