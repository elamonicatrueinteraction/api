require 'rails_helper'

RSpec.describe DeliveriesController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ {} }

    it { expect(get: '/deliveries').not_to be_routable }
    it { expect(get: '/deliveries/new').not_to be_routable }
    it { expect(get: '/deliveries/1').not_to be_routable }
    it { expect(get: '/deliveries/1/edit').not_to be_routable }
    it { expect(post: '/deliveries').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'create') ) }
    it { expect(put: '/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'update', id: '1') ) }
    it { expect(delete: '/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'destroy', id: '1') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/deliveries').not_to be_routable }
      it { expect(get: '/deliveries/new').not_to be_routable }
      it { expect(get: '/deliveries/1').not_to be_routable }
      it { expect(get: '/deliveries/1/edit').not_to be_routable }
      it { expect(post: '/deliveries').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'create') ) }
      it { expect(put: '/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'update', id: '1') ) }
      it { expect(delete: '/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'destroy', id: '1') ) }
    end
  end

  describe 'some resources under orders' do
    let(:routes_params){ { order_id: '1' } }

    it { expect(get: '/orders/1/deliveries').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'index') ) }
    it { expect(get: '/orders/1/deliveries/new').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'show', id: 'new') ) }
    it { expect(get: '/orders/1/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'show', id: '1') ) }
    it { expect(get: '/orders/1/deliveries/1/edit').not_to be_routable }
    it { expect(post: '/orders/1/deliveries').not_to be_routable }
    it { expect(put: '/orders/1/deliveries/1').not_to be_routable }
    it { expect(delete: '/orders/1/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'destroy', id: '1') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/orders/1/deliveries').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'index') ) }
      it { expect(get: '/orders/1/deliveries/new').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'show', id: 'new') ) }
      it { expect(get: '/orders/1/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'show', id: '1') ) }
      it { expect(get: '/orders/1/deliveries/1/edit').not_to be_routable }
      it { expect(post: '/orders/1/deliveries').not_to be_routable }
      it { expect(put: '/orders/1/deliveries/1').not_to be_routable }
      it { expect(delete: '/orders/1/deliveries/1').to route_to( routes_params.merge(controller: 'v1/deliveries', action: 'destroy', id: '1') ) }
    end
  end
end
