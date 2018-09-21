require 'rails_helper'

RSpec.describe AddressesController, type: :routing do
  describe 'no REST to any resource' do
    it { expect(get: '/addresses').not_to be_routable }
    it { expect(get: '/addresses/new').not_to be_routable }
    it { expect(get: '/addresses/1').not_to be_routable }
    it { expect(get: '/addresses/1/edit').not_to be_routable }
    it { expect(post: '/addresses').not_to be_routable }
    it { expect(put: '/addresses/1').not_to be_routable }
    it { expect(delete: '/addresses/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/addresses').not_to be_routable }
      it { expect(get: '/addresses/new').not_to be_routable }
      it { expect(get: '/addresses/1').not_to be_routable }
      it { expect(get: '/addresses/1/edit').not_to be_routable }
      it { expect(post: '/addresses').not_to be_routable }
      it { expect(put: '/addresses/1').not_to be_routable }
      it { expect(delete: '/addresses/1').not_to be_routable }
    end
  end

  describe 'some resources under institutions' do
    let(:routes_params){ { protocol: 'https', institution_id: '1' } }

    it { expect(get: '/institutions/1/addresses').to route_to( routes_params.merge(controller: 'v1/addresses', action: 'index') ) }
    it { expect(get: '/institutions/1/addresses/new').not_to be_routable }
    it { expect(get: '/institutions/1/addresses/1').not_to be_routable }
    it { expect(get: '/institutions/1/addresses/1/edit').not_to be_routable }
    it { expect(post: '/institutions/1/addresses').to route_to( routes_params.merge(controller: 'v1/addresses', action: 'create') ) }
    it { expect(put: '/institutions/1/addresses/1').to route_to( routes_params.merge( controller: 'v1/addresses', action: 'update', id: '1') ) }
    it { expect(delete: '/institutions/1/addresses/1').to route_to( routes_params.merge(controller: 'v1/addresses', action: 'destroy', id: '1') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/institutions/1/addresses').to route_to( routes_params.merge(controller: 'v1/addresses', action: 'index') ) }
      it { expect(get: '/institutions/1/addresses/new').not_to be_routable }
      it { expect(get: '/institutions/1/addresses/1').not_to be_routable }
      it { expect(get: '/institutions/1/addresses/1/edit').not_to be_routable }
      it { expect(post: '/institutions/1/addresses').to route_to( routes_params.merge(controller: 'v1/addresses', action: 'create') ) }
      it { expect(put: '/institutions/1/addresses/1').to route_to( routes_params.merge( controller: 'v1/addresses', action: 'update', id: '1') ) }
      it { expect(delete: '/institutions/1/addresses/1').to route_to( routes_params.merge(controller: 'v1/addresses', action: 'destroy', id: '1') ) }
    end
  end

end
