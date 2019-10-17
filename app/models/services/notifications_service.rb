module Services
  class NotificationsService < HttpUsersService
    RESOURCE = 'notification'.freeze
    ENDPOINT = "#{SERVICE_BASE_URL}/#{RESOURCE}"

    def dispatch(body: )
      response = HTTParty.post(endpoint, headers: HEADERS, body: body)
      response.code.to_s != "200"
    end
  end
end