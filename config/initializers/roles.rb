# Uggly hack to make some fields to appear

if Rails.env.test?
  puts 'Patched activeresource'
  class ActiveResourcePatch
    def initialize
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
        "Accept" => "application/json",
        "Authorization" => "Token token=#{USER_SERVICE_TOKEN}"
      }

      ros_request_headers = {
        "Accept" => "application/json",
        "Authorization" => "Token token=#{USER_SERVICE_TOKEN}",
        "X-Network-ID" => "ROS"
      }

      ActiveResource::HttpMock.respond_to do |mock|
        mock.get('/resources/districts.json', request_headers, districts.to_json)
        mock.get("/resources/institutions.json", request_headers, [institution].to_json)
        mock.get("/resources/institutions/#{institution[:id]}.json",
                 request_headers, institution.to_json)
        mock.get("/resources/institutions/fake-id.json", request_headers, nil, 404)
        mock.get('/resources/users.json', request_headers, users.to_json)
        mock.get('/resources/users.json?email=dummy%40nilus.org', request_headers, users.to_json)
        mock.get("/resources/users/#{users.first[:id]}.json", request_headers, users.first.to_json)
        mock.get("/resources/addresses/#{address[:id]}.json", request_headers, address.to_json)
        mock.get("/resources/addresses/fake-id.json", request_headers, nil, 404)
        mock.get('/resources/addresses.json', request_headers, [address].to_json)
        mock.get("/resources/addresses.json?institution_id=#{institution[:id]}",
                 request_headers, [address].to_json)

       mock.get('/resources/districts.json', ros_request_headers, districts.to_json)
       mock.get("/resources/institutions.json", ros_request_headers, [institution].to_json)
       mock.get("/resources/institutions/#{institution[:id]}.json",
                ros_request_headers, institution.to_json)
       mock.get("/resources/institutions/fake-id.json", ros_request_headers, nil, 404)
       mock.get('/resources/users.json', ros_request_headers, users.to_json)
       mock.get('/resources/users.json?email=dummy%40nilus.org', ros_request_headers, users.to_json)
       mock.get("/resources/users/#{users.first[:id]}.json", ros_request_headers, users.first.to_json)
       mock.get("/resources/addresses/#{address[:id]}.json", ros_request_headers, address.to_json)
       mock.get("/resources/addresses/fake-id.json", ros_request_headers, nil, 404)
       mock.get('/resources/addresses.json', ros_request_headers, [address].to_json)
       mock.get("/resources/addresses.json?institution_id=#{institution[:id]}",
                ros_request_headers, [address].to_json)
      end
    end
  end

  ActiveResourcePatch.new

end
User.first

Rails.application.reloader.reload!
