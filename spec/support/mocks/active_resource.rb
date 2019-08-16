RSpec.configure do |config|
  WebMock.disable_net_connect!(allow: 'https://api.mercadopago.com')
  config.before(:each) do
    districts = [
      { name: 'Distrito Centro' },
      { name: 'Distrito Norte' },
      { name: 'Distrito Noroeste' },
      { name: 'Distrito Oeste' },
      { name: 'Distrito Sudoeste' },
      { name: 'Distrito Sur' }
    ]

    institution = {
      id: '37d4970a-53ea-49f5-a2f1-2cdf26f36454',
      legal_name: 'TEST INSTITUTION',
      uid_type: 'CUIT',
      uid: '30-71000841-4',
      name: 'BAR',
      beneficiaries: 400,
      offered_services: ['lunch'],
      district: districts.first,
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    }

    users = [
      {
        "id": "f8245403-703f-4f0d-974f-ec23f818391d",
        "username": "dummy",
        "email": "dummy@nilus.org",
        "active": false,
        "confirmed": false,
        "last_login_ip": "127.0.0.1",
        "last_login_at": "2018-11-14T15:24:26.815Z",
        "token_expire_at": 1547479466,
        "institution_id": "37d4970a-53ea-49f5-a2f1-2cdf26f36454",
        "profile": {
          "first_name": nil,
          "last_name": nil,
          "cellphone": nil
        },
        "networks": ["ROS"],
        "roles_mask": 255,
        "cities": []
      }
    ]

    address = {
      city: "Rosario",
      contact_cellphone: '111-11111',
      contact_email: 'dummy@nilus.org',
      contact_name: 'Test',
      coordinates: { type: "Point", coordinates: [-60.63752090000003, -32.9639928] },
      country: "AR",
      gps_coordinates: { type: "Point", coordinates: [-60.63752090000003, -32.9639928] },
      id: "fb803694-60f1-4f43-b04f-fb593f7a7871",
      institution_id: "37d4970a-53ea-49f5-a2f1-2cdf26f36454",
      latlng: "-32.9639928,-60.63752090000003",
      notes: '',
      open_hours: '12hs a 18hs',
      state: "Santa Fe",
      street_1: "Riobamba 739",
      street_2: 'Oro 2116',
      telephone: '111-1111',
      zip_code: '1414'
    }

    response_payment = {
        id: 5797753650,
        card: {},
        order: {},
        payer: { id: nil, type: "guest", email: nil, phone: {}, last_name: nil, first_name: nil, entity_type: nil, identification: {}},
        status: "approved",
        barcode: { type: "Code128C", width: 1, height: 30, content: "333500880000000MP33189385314100065200181800538"},
        refunds: [],
        acquirer: nil,
        captured: true,
        metadata: {},
        issuer_id: nil,
        live_mode: true,
        sponsor_id: nil,
        binary_mode: false,
        currency_id: "ARS",
        description: "NILUS/BAR - Pago por la orden #172e2c60-dfa6-4861-8587-85c28349d92d",
        fee_details: [],
        collector_id: 280994634,
        date_created: "2018-06-29T11:40:34.000-04:00",
        installments: 1,
        coupon_amount: 0,
        date_approved: "2019-05-03T13:11:30.000-04:00",
        status_detail: "approved",
        operation_type: "regular_payment",
        additional_info: {},
        merchant_number: nil,
        payment_type_id: "ticket",
        processing_mode: "aggregator",
        counter_currency: nil,
        deduction_schema: nil,
        notification_url: "https://api.nilus.org/webhooks/mercadopago/payment/bc94f6f6-7a0b-45ea-b22e-d03826b63a71",
        date_last_updated: "2018-06-29T11:40:34.000-04:00",
        payment_method_id: "pagofacil",
        authorization_code: nil,
        date_of_expiration: nil,
        external_reference: "bc94f6f6-7a0b-45ea-b22e-d03826b63a71",
        money_release_date: nil,
        transaction_amount: 500,
        merchant_account_id: nil,
        transaction_details: { overpaid_amount: 0, total_paid_amount: 500, verification_code: 5797753650, acquirer_reference: nil, installment_amount: 0, net_received_amount: 0, external_resource_url: "http://www.mercadopago.com/mla/payments/ticket/helper?payment_id=3877842579&payment_method_reference_id=3189385314&caller_id=321383840&hash=72e33d8e-86e1-4494-bd9c-1aa579d75a5c", financial_institution: nil, payable_deferral_period: nil, payment_method_reference_id: 5797753650},
        money_release_schema: nil,
        statement_descriptor: nil,
        call_for_authorize_id: nil,
        acquirer_reconciliation: [],
        differential_pricing_id: nil,
        transaction_amount_refunded: 0
    }

    response_not_found = {
        message: "Payment not found",
        error: "not_found",
        status: 404,
        cause: [{code: 2000, description: "Payment not found", data: nil}]
    }

    request_headers = {
      Authorization: "Token token=#{Rails.application.secrets.user_token}"
    }

    ros_request_headers = {
      Authorization: "Token token=#{Rails.application.secrets.user_token}",
      "X-Network-ID": "ROS"
    }

    user_service_endpoint = Rails.application.secrets.user_endpoint
    # New mocks
    stub_request(:get, user_service_endpoint + '/institutions.json').with(headers: request_headers).to_return(body: [institution].to_json)
    stub_request(:get, user_service_endpoint + '/districts.json').with(headers: request_headers).to_return(body: districts.to_json)
    stub_request(:get, user_service_endpoint + "/institutions.json").with(headers: request_headers).to_return(body: { institutions: [institution] }.to_json)
    stub_request(:get, user_service_endpoint + "/institutions/#{institution[:id]}.json").with(headers: request_headers).to_return(body: { institution: institution }.to_json)
    stub_request(:get, user_service_endpoint + "/institutions/fake-id.json").with(headers: request_headers).to_return(body: nil, status: 404)
    stub_request(:get, user_service_endpoint + '/users.json').with(headers: request_headers).to_return(body: users.to_json)
    stub_request(:get, user_service_endpoint + '/users.json?email=dummy%40nilus.org').with(headers: request_headers).to_return(body: users.to_json)
    stub_request(:get, user_service_endpoint + "/users/#{users.first[:id]}.json").with(headers: request_headers).to_return(body: users.first.to_json)
    stub_request(:get, user_service_endpoint + "/addresses/#{address[:id]}.json").with(headers: request_headers).to_return(body: { address: address }.to_json)
    stub_request(:get, user_service_endpoint + "/addresses/fake-id.json").with(headers: request_headers).to_return(body: nil, status: 404)
    stub_request(:get, user_service_endpoint + '/addresses.json').with(headers: request_headers).to_return(body: { addresses: [address] }.to_json)
    stub_request(:get, user_service_endpoint + "/addresses.json?institution_id=#{institution[:id]}").with(headers: request_headers).to_return(body: { addresses: [address] }.to_json)

    stub_request(:get, user_service_endpoint + '/districts.json').with(headers: ros_request_headers).to_return(body: districts.to_json)
    stub_request(:get, user_service_endpoint + "/institutions.json").with(headers: ros_request_headers).to_return(body: [institution].to_json)
    stub_request(:get, user_service_endpoint + "/institutions/#{institution[:id]}.json").with(headers: ros_request_headers).to_return(body: institution.to_json)
    stub_request(:get, user_service_endpoint + "/institutions/fake-id.json").with(headers: ros_request_headers).to_return(body: nil, status: 404)
    stub_request(:get, user_service_endpoint + '/users.json').with(headers: ros_request_headers).to_return(body: users.to_json)
    stub_request(:get, user_service_endpoint + '/users.json?email=dummy%40nilus.org').with(headers: ros_request_headers).to_return(body: users.to_json)
    stub_request(:get, user_service_endpoint + "/users/#{users.first[:id]}.json").with(headers: ros_request_headers).to_return(body: users.first.to_json)
    stub_request(:get, user_service_endpoint + "/addresses/#{address[:id]}.json").with(headers: ros_request_headers).to_return(body: address.to_json)
    stub_request(:get, user_service_endpoint + "/addresses/fake-id.json").with(headers: ros_request_headers).to_return(body: nil, status: 404)
    stub_request(:get, user_service_endpoint + '/addresses.json').with(headers: ros_request_headers).to_return(body: [address].to_json)
    stub_request(:get, user_service_endpoint + "/addresses.json?institution_id=#{institution[:id]}").with(headers: ros_request_headers).to_return(body: [address].to_json)

    stub_request(:put, user_service_endpoint + "/institutions/#{institution[:id]}.json")
        .with(headers: request_headers)
        .to_return(status: 200, body: "")

    stub_request(:get, "https://api.mercadopago.com/v1/payments/#{response_payment[:id]}?access_token=#{Rails.application.secrets.mercadopago_bar_access_token}")
        .to_return(status: 200, body: response_payment.to_json)

    # stub_request(:get, "https://api.mercadopago.com/v1/payments/#{response_payment[:id]}?access_token=#{Rails.application.secrets.mercadopago_bar_access_token}")
    #     .to_return(status: 404, body: response_not_found.to_json)

  end
end
