require 'rails_helper'
require 'helpers/meli_helpers'

describe 'MercadoPago payment creation and search' do

  let(:meli_test_client_id) { Rails.application.secrets.mercadopago_bar_public_key }
  let(:meli_test_client_secret) { Rails.application.secrets.mercadopago_bar_access_token }
  let(:meli_client) { Gateway::Mercadopago::MercadopagoClient.new(meli_test_client_secret) }
  let!(:order) { create(:order) }
  let!(:delivery) { create(:delivery, order: order) }

  before :all do
    $continue = true
  end

  around :each do |example|
    if $continue
      $continue = false
      example.run
      $continue = true unless example.exception
    else
      example.skip
    end
  end

  it "can know if prod tokens are being used" do
    fake_access_token = "APP_USR-729584710928375-554323-asdf658asdf5sd6f8as6d75f-837402938"
    fake_client_id = "APP_USR-sdf876sd-asd7-364j-123a-asdfs7689sd"
    are_test_tokens = MeliHelpers.mercadopago_test_credentials?(fake_client_id, fake_access_token)
    expect(are_test_tokens).to eq false
  end

  it "can know if prod access token is being used" do
    fake_access_token = "APP_USR-729584710928375-554323-asdf658asdf5sd6f8as6d75f-837402938"
    test_client_id = "TEST-sdf876sd-asd7-364j-123a-asdfs7689sd"
    are_test_tokens = MeliHelpers.mercadopago_test_credentials?(test_client_id, fake_access_token)
    expect(are_test_tokens).to eq false
  end

  it "can know if prod client_id is being used" do
    test_access_token = "TEST-729584710928375-554323-asdf658asdf5sd6f8as6d75f-837402938"
    fake_client_id = "APP_USR-sdf876sd-asd7-364j-123a-asdfs7689sd"
    are_test_tokens = MeliHelpers.mercadopago_test_credentials?(fake_client_id, test_access_token)
    expect(are_test_tokens).to eq false
  end

  it "can know if test tokens are being used" do
    fake_access_token = "TEST-729584710928375-554323-asdf658asdf5sd6f8as6d75f-837402938"
    fake_client_id = "TEST-sdf876sd-asd7-364j-123a-asdfs7689sd"
    are_test_tokens = MeliHelpers.mercadopago_test_credentials?(fake_client_id, fake_access_token)
    expect(are_test_tokens).to eq true
  end

  context 'when testing tokens can be validated' do

    before do
      unless MeliHelpers.mercadopago_test_credentials?(meli_test_client_id, meli_test_client_secret)
        raise 'Meli production tokens are being used'
      end
    end

    context 'when amount is bigger than 0' do
      it 'creates payment with order in mercadopago and cancels it' do
        CreatePayment.call(payable: order, amount: order.amount, payment_type: Payment::PaymentTypes::PAGOFACIL)
        expect(Payment.all.length).to eq 1
        payment = Payment.first
        expect(payment.status).to eq Payment::Types::PENDING
        expect(payment.gateway_id).to_not be_nil
        expect(payment.gateway_data).to_not eq({})
        expect(payment.network_id).to_not be_nil
        expect(payment.gateway).to eq 'Mercadopago'
        expect(Order.first.payments.length).to eq 1
        meli_coupon_id = payment.gateway_id
        response = meli_client.cancel_payment(meli_coupon_id)
        expect(response.status).to eq Payment::Types::CANCELLED
      end

      it 'creates payment with delivery in mercadopago and cancels it' do
        CreatePayment.call(payable: delivery, amount: delivery.amount, payment_type: 'ticket')
        expect(Payment.all.length).to eq 1
        payment = Payment.first
        expect(payment.status).to eq Payment::Types::PENDING
        expect(payment.gateway_id).to_not be_nil
        expect(payment.gateway_data).to_not eq({})
        expect(payment.network_id).to_not be_nil
        expect(payment.gateway).to eq 'Mercadopago'
        expect(Delivery.first.payments.length).to eq 1
        meli_coupon_id = payment.gateway_id
        response = meli_client.cancel_payment(meli_coupon_id)
        expect(response.status).to eq Payment::Types::CANCELLED
      end
    end
  end
end