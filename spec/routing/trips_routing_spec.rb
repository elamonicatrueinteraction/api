require 'rails_helper'

RSpec.describe TripsController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/trips').to route_to( routes_params.merge(controller: 'trips', action: 'index') ) }
    it { expect(get: '/trips/new').to route_to( routes_params.merge(controller: 'trips', action: 'show', id: 'new') ) }
    it { expect(get: '/trips/1').to route_to( routes_params.merge(controller: 'trips', action: 'show', id: '1') ) }
    it { expect(get: '/trips/1/edit').not_to be_routable }
    it { expect(post: '/trips').to route_to( routes_params.merge(controller: 'trips', action: 'create') ) }
    it { expect(put: '/trips/1').to route_to( routes_params.merge(controller: 'trips', action: 'update', id: '1') ) }
    it { expect(delete: '/trips/1').to route_to( routes_params.merge(controller: 'trips', action: 'destroy', id: '1') ) }
  end
end
