class AuthorizeUser
  prepend Service::Base

  def initialize(http_auth_header)
    @http_auth_header = http_auth_header
  end

  def call
    user
  end

  private

  def user
    if decoded_auth_token
      user = User.find_by(id: decoded_auth_token[:user_id], token_expire_at: decoded_auth_token[:exp] )

      @user ||= user if user && user.token_expire_at >= Time.now.to_i
    end

    @user || errors.add(:token, I18n.t('services.authorize_user.invalid_token')) && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(@http_auth_header)
  end

end
