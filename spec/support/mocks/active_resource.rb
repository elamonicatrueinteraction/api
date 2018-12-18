RSpec.configure do |config|
  WebMock.disable_net_connect!
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
      legal_name: 'BAR',
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

    request_headers = {
      Authorization:"Token token=#{USER_SERVICE_TOKEN}"
    }

    ros_request_headers = {
      Authorization:"Token token=#{USER_SERVICE_TOKEN}",
      "X-Network-ID": "ROS"
    }

    # New mocks
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/institutions.json').with(headers: request_headers).to_return(body: [institution].to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/districts.json').with(headers: request_headers).to_return(body: districts.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/institutions.json").with(headers: request_headers).to_return(body: {institutions: [institution]}.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/institutions/#{institution[:id]}.json").with(headers: request_headers).to_return(body: {institution: institution}.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/institutions/fake-id.json").with(headers: request_headers).to_return(body: nil, status: 404)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/users.json').with(headers: request_headers).to_return(body: users.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/users.json?email=dummy%40nilus.org').with(headers: request_headers).to_return(body: users.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/users/#{users.first[:id]}.json").with(headers: request_headers).to_return(body: users.first.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/addresses/#{address[:id]}.json").with(headers: request_headers).to_return(body: address.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/addresses/fake-id.json").with(headers: request_headers).to_return(body: nil, status: 404)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/addresses.json').with(headers: request_headers).to_return(body: {addresses: [address]}.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/addresses.json?institution_id=#{institution[:id]}").with(headers: request_headers).to_return(body: {addresses: [address]}.to_json)

    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/districts.json').with(headers: ros_request_headers).to_return(body: districts.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/institutions.json").with(headers: ros_request_headers).to_return(body: [institution].to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/institutions/#{institution[:id]}.json").with(headers: ros_request_headers).to_return(body: institution.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/institutions/fake-id.json").with(headers: ros_request_headers).to_return(body: nil, status: 404)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/users.json').with(headers: ros_request_headers).to_return(body: users.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/users.json?email=dummy%40nilus.org').with(headers: ros_request_headers).to_return(body: users.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/users/#{users.first[:id]}.json").with(headers: ros_request_headers).to_return(body: users.first.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/addresses/#{address[:id]}.json").with(headers: ros_request_headers).to_return(body: address.to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/addresses/fake-id.json").with(headers: ros_request_headers).to_return(body: nil, status: 404)
    stub_request(:get, USER_SERVICE_ENDPOINT+'/resources/addresses.json').with(headers: ros_request_headers).to_return(body: [address].to_json)
    stub_request(:get, USER_SERVICE_ENDPOINT+"/resources/addresses.json?institution_id=#{institution[:id]}").with(headers: ros_request_headers).to_return(body: [address].to_json)
  end
end
