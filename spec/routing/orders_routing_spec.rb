require 'rails_helper'

RSpec.describe OrdersController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/orders').to route_to( routes_params.merge(controller: 'v1/orders', action: 'index') ) }
    it { expect(get: '/orders/new').to route_to( routes_params.merge(controller: 'v1/orders', action: 'show', id: 'new') ) }
    it { expect(get: '/orders/1').to route_to( routes_params.merge(controller: 'v1/orders', action: 'show', id: '1') ) }
    it { expect(get: '/orders/1/edit').not_to be_routable }
    it { expect(post: '/orders').to route_to( routes_params.merge(controller: 'v1/orders', action: 'create') ) }
    it { expect(put: '/orders/1').not_to be_routable }
    it { expect(delete: '/orders/1').to route_to( routes_params.merge(controller: 'v1/orders', action: 'destroy', id: '1') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/orders').to route_to( routes_params.merge(controller: 'v1/orders', action: 'index') ) }
      it { expect(get: '/orders/new').to route_to( routes_params.merge(controller: 'v1/orders', action: 'show', id: 'new') ) }
      it { expect(get: '/orders/1').to route_to( routes_params.merge(controller: 'v1/orders', action: 'show', id: '1') ) }
      it { expect(get: '/orders/1/edit').not_to be_routable }
      it { expect(post: '/orders').to route_to( routes_params.merge(controller: 'v1/orders', action: 'create') ) }
      it { expect(put: '/orders/1').not_to be_routable }
      it { expect(delete: '/orders/1').to route_to( routes_params.merge(controller: 'v1/orders', action: 'destroy', id: '1') ) }
    end
  end

  describe 'some resources under institutions' do
    let(:routes_params){ { protocol: 'https', institution_id: '1' } }

    it { expect(get: '/institutions/1/orders').to route_to( routes_params.merge(controller: 'v1/orders', action: 'index') ) }
    it { expect(get: '/institutions/1/orders/new').not_to be_routable }
    it { expect(get: '/institutions/1/orders/1').not_to be_routable }
    it { expect(get: '/institutions/1/orders/1/edit').not_to be_routable }
    it { expect(post: '/institutions/1/orders').not_to be_routable }
    it { expect(put: '/institutions/1/orders/1').not_to be_routable }
    it { expect(delete: '/institutions/1/orders/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/institutions/1/orders').to route_to( routes_params.merge(controller: 'v1/orders', action: 'index') ) }
      it { expect(get: '/institutions/1/orders/new').not_to be_routable }
      it { expect(get: '/institutions/1/orders/1').not_to be_routable }
      it { expect(get: '/institutions/1/orders/1/edit').not_to be_routable }
      it { expect(post: '/institutions/1/orders').not_to be_routable }
      it { expect(put: '/institutions/1/orders/1').not_to be_routable }
      it { expect(delete: '/institutions/1/orders/1').not_to be_routable }
    end
  end
end
