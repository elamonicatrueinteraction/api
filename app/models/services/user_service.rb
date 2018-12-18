module Services
  class UserService < Services::Base
    service_path "#{USER_SERVICE_ENDPOINT}/resources"
    headers Authorization: "Token #{USER_SERVICE_TOKEN}"
  end
end
