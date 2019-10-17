module Services
  class HttpUsersService
    SERVICE_BASE_URL = "#{Rails.application.secrets.users_endpoint}/services".freeze
    HEADERS = {
      Authorization: "Token token=#{Rails.application.secrets.users_token}"
    }.freeze
  end
end