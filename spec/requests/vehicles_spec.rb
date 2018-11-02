require 'rails_helper'

RSpec.describe VehiclesController, type: :request do
  let(:user) { create(:user_with_profile) }
  let(:shipper) { create(:shipper) }

  describe "GET #index" do
    let!(:vehicles) { create_list(:vehicle, 2, shipper: shipper) }

    context 'nested under shippers path' do
      before { get "/shippers/#{shipper_id}/vehicles", headers: auth_headers(user) }

      context 'with valid shipper_id data' do
        let(:shipper_id) { shipper.id }

        it_behaves_like 'a successful request', :vehicles
        it { expect(json[:vehicles].size).to eq(2) }
        it { expect(response).to match_response_schema("vehicles") }
      end

      context 'with invalid shipper_id data' do
        let(:shipper_id) { SecureRandom.uuid }

        it_behaves_like 'a not_found request'
      end
    end
  end

  describe "POST #create" do
    let(:vehicle) { build_stubbed(:vehicle) }
    let(:shipper_id) { shipper.id }

    context 'nested under shippers path' do
      before { post "/shippers/#{shipper_id}/vehicles", headers: auth_headers(user), params: parameters }

      context 'with valid vehicle data' do
        let(:parameters) { { max_weight: 30, brand: vehicle.brand, model: vehicle.model, year: vehicle.year } }

        it_behaves_like 'a successful create request', :vehicle
        it { expect(response).to match_response_schema("vehicle") }
      end

      context 'with invalid vehicle data' do
        let(:parameters) { { max_weight: 30, brand: vehicle.brand, year: vehicle.year } }

        it_behaves_like 'a failed request'
      end
    end

    context 'on absolute path' do
      before { post "/vehicles", headers: auth_headers(user), params: parameters }

      context 'without shipper_id data' do
        let(:parameters) { { max_weight: 30, brand: vehicle.brand, model: vehicle.model, year: vehicle.year } }

        it_behaves_like 'a bad_request request'
      end

      context 'with valid shipper_id data' do
        context 'with valid vehicle data' do
          let(:parameters) { { max_weight: 30, brand: vehicle.brand, model: vehicle.model, year: vehicle.year, shipper_id: shipper_id } }

          it_behaves_like 'a successful create request', :vehicle
          it { expect(response).to match_response_schema("vehicle") }
        end

        context 'with invalid vehicle data' do
          let(:parameters) { { brand: vehicle.brand, year: vehicle.year, shipper_id: shipper_id } }

          it_behaves_like 'a failed request'
        end
      end
    end
  end

  describe "PUT/PATCH #update" do
    let(:vehicle) { create(:vehicle, shipper: shipper) }
    let(:shipper_id) { shipper.id }
    let(:vehicle_id) { vehicle.id }
    let(:vehicle_update) { build_stubbed(:vehicle) }

    context 'nested under shippers path' do
      before { patch "/shippers/#{shipper_id}/vehicles/#{vehicle_id}", headers: auth_headers(user), params: parameters }

      context 'with valid data' do
        let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

        it_behaves_like 'a successful request', :vehicle
        it { expect(response).to match_response_schema("vehicle") }
      end

      context 'with invalid data' do
        let(:parameters) { { model: nil, year: vehicle_update.year } }

        it_behaves_like 'a failed request'
      end

      context 'with invalid vehicle id' do
        let(:vehicle_id) { SecureRandom.uuid }
        let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

        it_behaves_like 'a not_found request'
      end

      context 'with invalid shipper id' do
        let(:shipper_id) { SecureRandom.uuid }
        let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

        it_behaves_like 'a not_found request'
      end
    end

    context 'on absolute path' do
      before { patch "/vehicles/#{vehicle_id}", headers: auth_headers(user), params: parameters }

      context 'with shipper_id data' do
        context 'with valid data' do
          let(:parameters) { { max_weight: 30, brand: vehicle_update.brand, model: vehicle_update.model, year: vehicle.year, shipper_id: shipper_id } }

          it_behaves_like 'a successful request', :vehicle
          it { expect(response).to match_response_schema("vehicle") }
        end

        context 'with invalid data' do
          let(:parameters) { { model: nil, year: vehicle_update.year, shipper_id: shipper_id } }

          it_behaves_like 'a failed request'
        end

        context 'with invalid vehicle id' do
          let(:vehicle_id) { SecureRandom.uuid }
          let(:parameters) { { max_weight: 30, brand: vehicle_update.brand, model: vehicle_update.model, shipper_id: shipper_id } }

          it_behaves_like 'a not_found request'
        end

        context 'with invalid shipper id' do
          let(:parameters) { { max_weight: 30, brand: vehicle_update.brand, model: vehicle_update.model, shipper_id: SecureRandom.uuid } }

          it_behaves_like 'a not_found request'
        end
      end

      context 'without shipper_id data' do
        context 'with valid data' do
          let(:parameters) { { max_weight: 30, brand: vehicle_update.brand, model: vehicle_update.model, year: vehicle.year } }

          it_behaves_like 'a successful request', :vehicle
        end

        context 'with invalid data' do
          let(:parameters) { { model: nil, year: vehicle_update.year } }

          it_behaves_like 'a failed request'
        end

        context 'with invalid vehicle id' do
          let(:vehicle_id) { SecureRandom.uuid }
          let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

          it_behaves_like 'a not_found request'
        end
      end
    end
  end
end
