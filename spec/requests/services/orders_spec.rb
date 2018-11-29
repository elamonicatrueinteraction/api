require 'rails_helper'

RSpec.describe Services::OrdersController, type: :request do
  describe "GET #index" do
    let!(:orders) { create_list(:full_order, 3) }

    context 'direct orders path' do
      before { get '/services/orders', headers: resource_authentication_headers }

      it_behaves_like 'a successful request'
      it { expect(json.size).to eq(3) }
      it { expect(response).to match_response_schema("services/orders") }
    end

    context 'with a valid institution filter' do

      before { get "/services/orders", params: { institution_id: institution_id }, headers: resource_authentication_headers }

      context 'with valid institution_id data' do
        let(:institution_id) { orders.sample.receiver_id }

        it_behaves_like 'a successful request'
        it { expect(json.size).to eq(3) }
        it { expect(response).to match_response_schema("services/orders") }
      end

      context 'with invalid institution_id data' do
        let(:institution_id) { SecureRandom.uuid }

        it_behaves_like 'a successful request'
        it { expect(json.size).to eq(0) }
      end
    end
  end
end
