require 'rails_helper'

RSpec.describe ShipperApi::TripsController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/shipper/trips').to route_to( routes_params.merge(controller: 'shipper_api/trips', action: 'index') ) }
    it { expect(get: '/shipper/trips/new').to route_to( routes_params.merge(controller: 'shipper_api/trips', action: 'show', id: 'new') ) }
    it { expect(get: '/shipper/trips/1').to route_to( routes_params.merge(controller: 'shipper_api/trips', action: 'show', id: '1') ) }
    it { expect(get: '/shipper/trips/1/edit').not_to be_routable }
    it { expect(post: '/shipper/trips').not_to be_routable }
    it { expect(put: '/shipper/trips/1').not_to be_routable }
    it { expect(delete: '/shipper/trips/1').not_to be_routable }
  end
end
