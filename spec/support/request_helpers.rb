module Requests
  module JsonHelper
    def json
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module AuthHelpers
    def auth_headers(user)
      auth_token =  AuthenticateUser.call(user.email, user.password).result
      {
        'Authorization': "Bearer #{auth_token}"
      }
    end

    def shipper_auth_headers(shipper)
      auth_token =  ShipperApi::AuthenticateShipper.call(shipper.email, shipper.password).result
      {
        'Authorization': "Bearer #{auth_token}"
      }
    end

    def services_auth_headers(token)
      {
        'Authorization': "Token token=#{token}"
      }
    end
  end
end

RSpec.configure do |config|
  config.include Requests::JsonHelper,  type: :request
  config.include Requests::AuthHelpers, type: :request
end

