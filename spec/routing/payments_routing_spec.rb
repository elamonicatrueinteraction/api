require 'rails_helper'

RSpec.describe PaymentsController, type: :routing do
  describe 'no REST to any resource' do
    it { expect(get: '/payments').not_to be_routable }
    it { expect(get: '/payments/new').not_to be_routable }
    it { expect(get: '/payments/1').not_to be_routable }
    it { expect(get: '/payments/1/edit').not_to be_routable }
    it { expect(post: '/payments').not_to be_routable }
    it { expect(put: '/payments/1').not_to be_routable }
    it { expect(delete: '/payments/1').not_to be_routable }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/payments').not_to be_routable }
      it { expect(get: '/payments/new').not_to be_routable }
      it { expect(get: '/payments/1').not_to be_routable }
      it { expect(get: '/payments/1/edit').not_to be_routable }
      it { expect(post: '/payments').not_to be_routable }
      it { expect(put: '/payments/1').not_to be_routable }
      it { expect(delete: '/payments/1').not_to be_routable }
    end
  end

  describe 'some resources under orders' do
    let(:routes_params){ { order_id: '1' } }

    it { expect(get: '/orders/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'index') ) }
    it { expect(post: '/orders/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'create') ) }
    it { expect(get: '/orders/1/payments/2').to route_to( routes_params.merge(controller: 'v1/payments', action: 'show', id: '2') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/orders/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'index') ) }
      it { expect(post: '/orders/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'create') ) }
      it { expect(get: '/orders/1/payments/2').to route_to( routes_params.merge(controller: 'v1/payments', action: 'show', id: '2') ) }
    end
  end

  describe 'some resources under deliveries' do
    let(:routes_params){ { delivery_id: '1' } }

    it { expect(get: '/deliveries/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'index') ) }
    it { expect(post: '/deliveries/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'create') ) }
    it { expect(get: '/deliveries/1/payments/2').to route_to( routes_params.merge(controller: 'v1/payments', action: 'show', id: '2') ) }

    context 'v1' do
      before { set_accept_header(version: 1) }

      it { expect(get: '/deliveries/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'index') ) }
      it { expect(post: '/deliveries/1/payments').to route_to( routes_params.merge(controller: 'v1/payments', action: 'create') ) }
      it { expect(get: '/deliveries/1/payments/2').to route_to( routes_params.merge(controller: 'v1/payments', action: 'show', id: '2') ) }
    end
  end
end
