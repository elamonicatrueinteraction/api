require 'rails_helper'

RSpec.describe ShipperApi::MilestonesController, type: :routing do
  describe 'no REST to any resource' do
    it { expect(get: '/shipper/milestones').not_to be_routable }
    it { expect(get: '/shipper/milestones/new').not_to be_routable }
    it { expect(get: '/shipper/milestones/1').not_to be_routable }
    it { expect(get: '/shipper/milestones/1/edit').not_to be_routable }
    it { expect(post: '/shipper/milestones').not_to be_routable }
    it { expect(put: '/shipper/milestones/1').not_to be_routable }
    it { expect(delete: '/shipper/milestones/1').not_to be_routable }
  end

  describe 'some resources under trips' do
    let(:routes_params){ { protocol: 'https', trip_id: '1' } }

    it { expect(get: '/shipper/trips/1/milestones').not_to be_routable }
    it { expect(get: '/shipper/trips/1/milestones/new').not_to be_routable }
    it { expect(get: '/shipper/trips/1/milestones/1').not_to be_routable }
    it { expect(get: '/shipper/trips/1/milestones/1/edit').not_to be_routable }
    it { expect(post: '/shipper/trips/1/milestones').to route_to( routes_params.merge(controller: 'shipper_api/milestones', action: 'create') ) }
    it { expect(put: '/shipper/trips/1/milestones/1').not_to be_routable }
    it { expect(delete: '/shipper/trips/1/milestones/1').not_to be_routable }
  end
end
