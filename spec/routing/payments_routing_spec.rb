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
  end

  describe 'some resources under orders' do
    let(:routes_params){ { protocol: 'https', order_id: '1' } }

    it { expect(get: '/orders/1/payments').to route_to( routes_params.merge(controller: 'payments', action: 'index') ) }
    it { expect(post: '/orders/1/payments').to route_to( routes_params.merge(controller: 'payments', action: 'create') ) }
    it { expect(get: '/orders/1/payments/2').to route_to( routes_params.merge(controller: 'payments', action: 'show', id: '2') ) }
  end

  describe 'some resources under deliveries' do
    let(:routes_params){ { protocol: 'https', delivery_id: '1' } }

    it { expect(get: '/deliveries/1/payments').to route_to( routes_params.merge(controller: 'payments', action: 'index') ) }
    it { expect(post: '/deliveries/1/payments').to route_to( routes_params.merge(controller: 'payments', action: 'create') ) }
    it { expect(get: '/deliveries/1/payments/2').to route_to( routes_params.merge(controller: 'payments', action: 'show', id: '2') ) }
  end
end