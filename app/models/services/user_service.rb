module Services
  class UserService < Services::Base
    service_path 'http://localhost:3010/resources'
    headers Authorization: 'Token DEFAULT_TOKEN'
  end
end
