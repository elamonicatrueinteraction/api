require 'rails_helper'

RSpec.describe DeliveriesController, type: :routing do
  describe 'some REST resources' do
    let(:routes_params){ { protocol: 'https' } }

    it { expect(get: '/deliveries').not_to be_routable }
    it { expect(get: '/deliveries/new').not_to be_routable }
    it { expect(get: '/deliveries/1').not_to be_routable }
    it { expect(get: '/deliveries/1/edit').not_to be_routable }
    it { expect(post: '/deliveries').to route_to( routes_params.merge(controller: 'deliveries', action: 'create') ) }
    it { expect(put: '/deliveries/1').to route_to( routes_params.merge(controller: 'deliveries', action: 'update', id: '1') ) }
    it { expect(delete: '/deliveries/1').to route_to( routes_params.merge(controller: 'deliveries', action: 'destroy', id: '1') ) }
  end

  describe 'some resources under orders' do
    let(:routes_params){ { protocol: 'https', order_id: '1' } }

    it { expect(get: '/orders/1/deliveries').to route_to( routes_params.merge(controller: 'deliveries', action: 'index') ) }
    it { expect(get: '/orders/1/deliveries/new').to route_to( routes_params.merge(controller: 'deliveries', action: 'show', id: 'new') ) }
    it { expect(get: '/orders/1/deliveries/1').to route_to( routes_params.merge(controller: 'deliveries', action: 'show', id: '1') ) }
    it { expect(get: '/orders/1/deliveries/1/edit').not_to be_routable }
    it { expect(post: '/orders/1/deliveries').not_to be_routable }
    it { expect(put: '/orders/1/deliveries/1').not_to be_routable }
    it { expect(delete: '/orders/1/deliveries/1').to route_to( routes_params.merge(controller: 'deliveries', action: 'destroy', id: '1') ) }
  end
end
