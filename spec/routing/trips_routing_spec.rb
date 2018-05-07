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

  describe 'some other member paths' do
    let(:routes_params){ { protocol: 'https', id: '1' } }

    it { expect(post: '/trips/1/broadcast').to route_to( routes_params.merge(controller: 'trips', action: 'broadcast') ) }
    it { expect(get: '/trips/1/broadcast').not_to be_routable }
  end

  describe 'some resources under institutions' do
    let(:routes_params){ { protocol: 'https', institution_id: '1' } }

    it { expect(get: '/institutions/1/trips').to route_to( routes_params.merge(controller: 'trips', action: 'index') ) }
    it { expect(get: '/institutions/1/trips/new').not_to be_routable }
    it { expect(get: '/institutions/1/trips/1').not_to be_routable }
    it { expect(get: '/institutions/1/trips/1/edit').not_to be_routable }
    it { expect(post: '/institutions/1/trips').not_to be_routable }
    it { expect(put: '/institutions/1/trips/1').not_to be_routable }
    it { expect(delete: '/institutions/1/orders/1').not_to be_routable }
  end 
end
