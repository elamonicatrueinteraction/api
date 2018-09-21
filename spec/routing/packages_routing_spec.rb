require 'rails_helper'

RSpec.describe PackagesController, type: :routing do
  describe 'no REST to any resource' do
    it { expect(get: '/packages').not_to be_routable }
    it { expect(get: '/packages/new').not_to be_routable }
    it { expect(get: '/packages/1').not_to be_routable }
    it { expect(get: '/packages/1/edit').not_to be_routable }
    it { expect(post: '/packages').not_to be_routable }
    it { expect(put: '/packages/1').not_to be_routable }
    it { expect(delete: '/packages/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/packages').not_to be_routable }
      it { expect(get: '/packages/new').not_to be_routable }
      it { expect(get: '/packages/1').not_to be_routable }
      it { expect(get: '/packages/1/edit').not_to be_routable }
      it { expect(post: '/packages').not_to be_routable }
      it { expect(put: '/packages/1').not_to be_routable }
      it { expect(delete: '/packages/1').not_to be_routable }
    end
  end

  describe 'some resources under deliveries' do
    let(:routes_params){ { protocol: 'https', delivery_id: '1' } }

    it { expect(get: '/deliveries/1/packages').to route_to( routes_params.merge(controller: 'v1/packages', action: 'index') ) }
    it { expect(get: '/deliveries/1/packages/new').to route_to( routes_params.merge(controller: 'v1/packages', action: 'show', id: 'new') ) }
    it { expect(get: '/deliveries/1/packages/1').to route_to( routes_params.merge(controller: 'v1/packages', action: 'show', id: '1') ) }
    it { expect(get: '/deliveries/1/packages/1/edit').not_to be_routable }
    it { expect(post: '/deliveries/1/packages').to route_to( routes_params.merge(controller: 'v1/packages', action: 'create') ) }
    it { expect(put: '/deliveries/1/packages/1').to route_to( routes_params.merge( controller: 'v1/packages', action: 'update', id: '1') ) }
    it { expect(delete: '/deliveries/1/packages/1').to route_to( routes_params.merge(controller: 'v1/packages', action: 'destroy', id: '1') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/deliveries/1/packages').to route_to( routes_params.merge(controller: 'v1/packages', action: 'index') ) }
      it { expect(get: '/deliveries/1/packages/new').to route_to( routes_params.merge(controller: 'v1/packages', action: 'show', id: 'new') ) }
      it { expect(get: '/deliveries/1/packages/1').to route_to( routes_params.merge(controller: 'v1/packages', action: 'show', id: '1') ) }
      it { expect(get: '/deliveries/1/packages/1/edit').not_to be_routable }
      it { expect(post: '/deliveries/1/packages').to route_to( routes_params.merge(controller: 'v1/packages', action: 'create') ) }
      it { expect(put: '/deliveries/1/packages/1').to route_to( routes_params.merge( controller: 'v1/packages', action: 'update', id: '1') ) }
      it { expect(delete: '/deliveries/1/packages/1').to route_to( routes_params.merge(controller: 'v1/packages', action: 'destroy', id: '1') ) }
    end
  end
end
