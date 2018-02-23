require 'rails_helper'

RSpec.describe CreateOrder do
  subject(:context) { described_class.call(allowed_params) }

  let(:result) { context.result }
  let(:giver) { create(:company_with_address) }
  let(:receiver) { create(:organization_with_address) }
  let(:giver_id) { giver.id }
  let(:receiver_id) { receiver.id }
  let(:origin) { create(:company_with_address) }
  let(:destination) { create(:company_with_address) }
  let(:origin_id) { origin.addresses.first.id }
  let(:destination_id) { destination.addresses.first.id }

  let(:order_params) {
    {
      giver_id: giver_id,
      receiver_id: receiver_id,
      expiration: '',
      amount: 1_000,
      bonified_amount: 200,
    }
  }

  let(:delivery_params) {
    {
      origin_id: origin_id,
      destination_id: destination_id,
      delivery_amount: 300,
      delivery_bonified_amount: 50,
    }
  }

  let(:packages_params) {
    {
      packages: attributes_for_list(:single_package, 2)
    }
  }

  describe ".call (with only order params)" do
    let(:allowed_params) { HashWithIndifferentAccess.new(order_params) }

    context 'when the context is successful' do
      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:order) { Order.last }

        before { context }

        it { expect(result).to eq(order) }
        it { expect(result).to be_a(Order) }
        it 'matching order params' do
          expect(result.amount).to eq(1_000)
          expect(result.bonified_amount).to eq(200)
        end
        it { expect(result.deliveries).to be_empty }
        it { expect(result.packages).to be_empty }
      end
    end

    context 'when the context is not successful' do
      let(:giver_id) { SecureRandom.uuid }
      let(:receiver_id) { SecureRandom.uuid }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Order.all).to be_empty }
      end
    end
  end

  describe ".call (with order and delivery params)" do
    let(:allowed_params) { HashWithIndifferentAccess.new(order_params.merge(delivery_params)) }

    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:order) { Order.last }

        before { context }

        it { expect(result).to eq(order) }
        it { expect(result).to be_a(Order) }
        it { expect(result.deliveries).not_to be_empty }
        it { expect(result.deliveries.size).to eq(1) }
        it 'matching delivery params' do
          delivery = result.deliveries.first
          expect(delivery.amount).to eq(300)
          expect(delivery.bonified_amount).to eq(50)
        end
        it { expect(result.packages).to be_empty }
      end
    end

    context 'when the context is not successful' do
      let(:origin_id) { SecureRandom.uuid }

      it 'fails' do
        expect(context).to be_failure
      end

      describe 'result is nil' do
        before { context }

        it { expect(result).to be_nil }
        it { expect(Order.all).to be_empty }
        it { expect(Delivery.all).to be_empty }
      end
    end
  end

  describe ".call (with order, delivery and packages params)" do
    let(:allowed_params) { HashWithIndifferentAccess.new(order_params.merge(delivery_params).merge(packages_params)) }

    context 'when the context is successful' do

      it 'succeeds' do
        expect(context).to be_success
      end

      describe 'valid result' do
        let(:order) { Order.last }

        before { context }

        it { expect(result).to eq(order) }
        it { expect(result).to be_a(Order) }
        it { expect(result.deliveries).not_to be_empty }
        it { expect(result.deliveries.size).to eq(1) }
        it { expect(result.packages).not_to be_empty }
        it { expect(result.packages.size).to eq(2) }
        it 'matching packages params' do
          packages = result.packages
          expect(packages.map(&:quantity)).to eq(packages_params[:packages].map{ |p| p[:quantity] })
        end
      end
    end
  end
end
