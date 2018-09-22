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

    unless @user
      return errors.add(:token, I18n.t('services.authorize_user.invalid_token')) && nil
    end

    # TO-DO: We should think a better authorization schema if we are
    # going to be checking this on other levels, for now is only to
    # prevent buyers to enter the main application (dash.nilus.org)
    return @user if @user.has_any_role?(*allowed_roles)

    errors.add(:token, I18n.t('services.authorize_user.not_allowed')) && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(@http_auth_header)
  end

  def allowed_roles
    %i[
      god_admin
      logistics_admin
      marketplace_admin
      logistics_manager
      marketplace_manager
      shop_admin
      shop_manager
    ]
  end

end
