require 'rails_helper'
require 'securerandom'

RSpec.describe VehiclesController, type: :request do
  let(:user) { create(:user_with_profile) }
  let(:auth_token) { AuthenticateUser.call(user.email, user.password).result }
  let(:shipper) { create(:shipper) }

  describe "GET #index" do
    let!(:vehicles) { create_list(:vehicle, 2, shipper: shipper) }

    context 'nested under shippers path' do
      before { get "/shippers/#{shipper_id}/vehicles", headers: { Authorization: "Token #{auth_token}" } }

      context 'with valid shipper_id data' do
        let(:shipper_id) { shipper.id }

        it "returns and array of vehicles" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('vehicles')
          expect(json['vehicles']).not_to be_empty
          expect(json['vehicles'].size).to be(2)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid shipper_id data' do
        let(:shipper_id) { SecureRandom.uuid }

        it "returns the errors" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('error')
          expect(json['error']).not_to be_empty
        end

        it "returns status code 404" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "POST #create" do
    let(:vehicle) { build(:vehicle) }
    let(:shipper_id) { shipper.id }

    context 'nested under shippers path' do
      before { post "/shippers/#{shipper_id}/vehicles", headers: { Authorization: "Token #{auth_token}" }, params: parameters }

      context 'with valid vehicle data' do
        let(:parameters) { { brand: vehicle.brand, model: vehicle.model, year: vehicle.year } }

        it "returns the created vehicle" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('vehicle')
          expect(json['vehicle']).not_to be_empty
        end

        it "returns status code 201" do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid vehicle data' do
        let(:parameters) { { brand: vehicle.brand, year: vehicle.year } }

        it "returns the errors" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('error')
          expect(json['error']).not_to be_empty
        end

        it "returns status code 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'on absolute path' do
      before { post "/vehicles", headers: { Authorization: "Token #{auth_token}" }, params: parameters }

      context 'without shipper_id data' do
        let(:parameters) { { brand: vehicle.brand, model: vehicle.model, year: vehicle.year } }

        it "returns the errors" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('error')
          expect(json['error']).not_to be_empty
        end

        it "returns status code 400" do
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'with valid shipper_id data' do
        context 'with valid vehicle data' do
          let(:parameters) { { brand: vehicle.brand, model: vehicle.model, year: vehicle.year, shipper_id: shipper_id } }

          it "returns the created vehicle" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('vehicle')
            expect(json['vehicle']).not_to be_empty
          end

          it "returns status code 201" do
            expect(response).to have_http_status(:created)
          end
        end

        context 'with invalid vehicle data' do
          let(:parameters) { { brand: vehicle.brand, year: vehicle.year, shipper_id: shipper_id } }

          it "returns the errors" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('error')
            expect(json['error']).not_to be_empty
          end

          it "returns status code 422" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe "PUT/PATCH #update" do
    let(:vehicle) { create(:vehicle, shipper: shipper) }
    let(:shipper_id) { shipper.id }
    let(:vehicle_id) { vehicle.id }
    let(:vehicle_update) { build(:vehicle) }

    context 'nested under shippers path' do
      before { patch "/shippers/#{shipper_id}/vehicles/#{vehicle_id}", headers: { Authorization: "Token #{auth_token}" }, params: parameters }

      context 'with valid data' do
        let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

        it "returns the updated vehicle" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('vehicle')
          expect(json['vehicle']).not_to be_empty
        end

        it "returns status code 200" do
          expect(response).to have_http_status(:success)
        end
      end

      context 'with invalid data' do
        let(:parameters) { { model: nil, year: vehicle_update.year } }

        it "returns the errors" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('error')
          expect(json['error']).not_to be_empty
        end

        it "returns status code 422" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with invalid vehicle id' do
        let(:vehicle_id) { SecureRandom.uuid }
        let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

        it "returns the errors" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('error')
          expect(json['error']).not_to be_empty
        end

        it "returns status code 404" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context 'with invalid shipper id' do
        let(:shipper_id) { SecureRandom.uuid }
        let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

        it "returns the errors" do
          expect(json).not_to be_empty
          expect(json.keys).to contain_exactly('error')
          expect(json['error']).not_to be_empty
        end

        it "returns status code 404" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'on absolute path' do
      before { patch "/vehicles/#{vehicle_id}", headers: { Authorization: "Token #{auth_token}" }, params: parameters }

      context 'with shipper_id data' do
        context 'with valid data' do
          let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model, year: vehicle.year, shipper_id: shipper_id } }

          it "returns the updated vehicle" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('vehicle')
            expect(json['vehicle']).not_to be_empty
          end

          it "returns status code 200" do
            expect(response).to have_http_status(:success)
          end
        end

        context 'with invalid data' do
          let(:parameters) { { model: nil, year: vehicle_update.year, shipper_id: shipper_id } }

          it "returns the errors" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('error')
            expect(json['error']).not_to be_empty
          end

          it "returns status code 422" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'with invalid vehicle id' do
          let(:vehicle_id) { SecureRandom.uuid }
          let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model, shipper_id: shipper_id } }

          it "returns the errors" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('error')
            expect(json['error']).not_to be_empty
          end

          it "returns status code 404" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context 'with invalid shipper id' do
          let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model, shipper_id: SecureRandom.uuid } }

          it "returns the errors" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('error')
            expect(json['error']).not_to be_empty
          end

          it "returns status code 404" do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context 'without shipper_id data' do
        context 'with valid data' do
          let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model, year: vehicle.year } }

          it "returns the updated vehicle" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('vehicle')
            expect(json['vehicle']).not_to be_empty
          end

          it "returns status code 200" do
            expect(response).to have_http_status(:success)
          end
        end

        context 'with invalid data' do
          let(:parameters) { { model: nil, year: vehicle_update.year } }

          it "returns the errors" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('error')
            expect(json['error']).not_to be_empty
          end

          it "returns status code 422" do
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'with invalid vehicle id' do
          let(:vehicle_id) { SecureRandom.uuid }
          let(:parameters) { { brand: vehicle_update.brand, model: vehicle_update.model } }

          it "returns the errors" do
            expect(json).not_to be_empty
            expect(json.keys).to contain_exactly('error')
            expect(json['error']).not_to be_empty
          end

          it "returns status code 404" do
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end
end
