module Services
  class HttpUsersService
    SERVICE_BASE_URL = "#{Rails.application.secrets.user_endpoint}".freeze
    HEADERS = {
      Authorization: "Token token=#{Rails.application.secrets.user_token}"
    }.freeze
  end
end