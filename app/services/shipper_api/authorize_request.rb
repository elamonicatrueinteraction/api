module ShipperApi
  class AuthorizeRequest
    prepend Service::Base

    def initialize(headers = {})
      @headers = headers
    end

    def call
      shipper
    end

    private

    def shipper
      if decoded_auth_token
        shipper = Shipper.unscoped.find_by(id: decoded_auth_token[:shipper_id], token_expire_at: decoded_auth_token[:exp] )

        @shipper ||= shipper if shipper && shipper.token_expire_at >= Time.now.to_i
      end

      @shipper || errors.add(:token, I18n.t('services.api.authorize_request.invalid_token')) && nil
    end

    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    end

    def http_auth_header
      return @headers['Authorization'].split(' ').last if @headers['Authorization'].present?

      errors.add(:token, I18n.t('services.api.authorize_request.missing_token'))
      nil
    end

  end
end
