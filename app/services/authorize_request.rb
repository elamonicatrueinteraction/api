class AuthorizeRequest
  prepend Service::Base

  def initialize(headers = {})
    @headers = headers
  end

  def call
    authorize_request
  end

  private

  def authorize_request
    authorize_user = AuthorizeUser.call(http_auth_header)

    @user = authorize_user.result

    @user || errors.add_multiple_errors(authorize_user.errors) && nil
  end

  def http_auth_header
    return @headers['Authorization'].split(' ').last if @headers['Authorization'].present?

    errors.add(:token, I18n.t('services.authorize_request.missing_token'))
    nil
  end

end
