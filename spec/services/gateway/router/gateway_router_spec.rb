require 'rails_helper'

xdescribe 'GatewayRouter' do
  # ROS
  context 'when network is ROS' do
    let!(:network) {'ROS'}

    context 'when payable is Order' do
      let!(:payable) {create(:order_with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: network.to_sym)
      }
      it 'returns ROS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is Delivery' do
      let!(:order) { create(:order, network_id: network)}
      let!(:payable) {create(:delivery_with_pending_payment, order: order)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Order activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: network.to_sym)
      }
      it 'returns ROS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Delivery activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, :with_delivery_as_activity, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

  end

  # MDQ
  context 'when network is MDQ' do
    let!(:network) {'MDQ'}
    context 'when payable is Order' do
      let!(:payable) {create(:order_with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: network.to_sym)
      }
      it 'returns MDQ Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is Delivery' do
      let!(:order) { create(:order, network_id: network)}
      let!(:payable) {create(:delivery_with_pending_payment, order: order)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Order activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: network.to_sym)
      }
      it 'returns MDQ Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Delivery activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, :with_delivery_as_activity, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

  end

  # MCBA
  context 'when network is MCBA' do
    let!(:network) {'MCBA'}

    context 'when payable is Order' do
      let!(:payable) {create(:order_with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is Delivery' do
      let!(:order) { create(:order, network_id: network)}
      let!(:payable) {create(:delivery_with_pending_payment, order: order)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Order activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Delivery activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, :with_delivery_as_activity, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end

    end
  end

  # LP
  context 'when network is LP' do
    let!(:network) {'LP'}

    context 'when payable is Order' do
      let!(:order) { create(:order, network_id: network)}
      let!(:payable) {create(:delivery_with_pending_payment, order: order)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is Delivery' do
      let!(:order) { create(:order, network_id: network)}
      let!(:payable) {create(:delivery_with_pending_payment, order: order)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Order activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end

    context 'when payable is UntrackedActivity for Delivery activity' do
      let!(:payable) {create(:untracked_activity, :with_pending_payment, :with_delivery_as_activity, network_id: network)}
      let!(:gateway_provider) {spy('gatewayProvider')}
      before {
        expect(gateway_provider).to receive(:gateway_for).with(service: :Mercadopago, payee_code: :NILUS)
      }
      it 'returns NILUS Mercadopago gateway' do
        router = Gateway::Router::GatewayRouter.new(gateway_provider: gateway_provider)
        router.route_gateway(payment: payable.payments.first, payment_type: 'rapipago', network_id: network)
      end
    end
  end
end