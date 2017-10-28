class AuthorizeRequest
  prepend Service::Base

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  def user
    if decoded_auth_token
      user = User.find_by(id: decoded_auth_token[:user_id], token_expire_at: decoded_auth_token[:exp] )

      @user ||= user if user && user.token_expire_at >= Time.now.to_i
    else
      @user = nil
    end

    @user || errors.add(:token, I18n.t('services.authorize_request.invalid_token')) && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    return @headers['Authorization'].split(' ').last if @headers['Authorization'].present?

    errors.add(:token, I18n.t('services.authorize_request.missing_token'))
    nil
  end

end
