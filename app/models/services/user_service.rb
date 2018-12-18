module Services
  class UserService < Services::Base
    service_path "#{USER_SERVICE_ENDPOINT}/resources"
    headers Authorization: "Token token=#{USER_SERVICE_TOKEN}"

    def read_attribute_for_serialization(attr)
      send(attr)
    end
  end
end
