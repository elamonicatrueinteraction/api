require 'rails_helper'

RSpec.describe Webhooks::MercadopagoController, type: :routing do
  describe 'some specify routes only' do
    let(:routes_params){ {} }

    it { expect(get: '/webhooks/mercadopago/payment/1').not_to be_routable }
    it { expect(post: '/webhooks/mercadopago/payment/1').to route_to( routes_params.merge(controller: 'webhooks/mercadopago', action: 'payment_notification', uuid: '1') ) }
  end
end
