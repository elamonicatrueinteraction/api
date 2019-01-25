class AuthorizeUser
  prepend Service::Base

  def initialize(http_auth_header, request_context)
    @http_auth_header = http_auth_header
    @request_context = request_context
  end

  def call
    authorize_user
  end

  private

  def authorize_user
    @user = load_user_from_authentication

    unless @user
      return errors.add(:token, I18n.t('services.authorize_user.invalid_token')) && nil
    end

    return @user if ensure_user_ability

    errors.add(:token, I18n.t('services.authorize_user.not_allowed')) && nil
  end

  def load_user_from_authentication
    request = Typhoeus::Request.new(
      "https://#{URI.parse(Rails.application.secrets.user_endpoint).host}/authorize",
      headers: user_authentication_headers,
      method: :get
    )
    response = request.run
    body = json_load(response.body)

    response.success? ? User.new(body, true) : nil
  end

  # TO-DO: We should specify the logic here. The idea is to be able
  # to be sure that the user is allowed to do the attemped action
  # that's why we have in this service the request_context
  #
  # Right now the logic is very basic and that's why it's written like this
  def ensure_user_ability
    @user.has_any_role?(*allowed_roles)
  end

  def user_authentication_headers
    {
      "Accept-Encoding" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@http_auth_header}",
      "Nilus-Service-Authorization" => "Token #{Rails.application.secrets.user_token}"
    }
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

  # TO-DO: This is a duplicated method, we should probably think a better
  # place for this kind of helpers methods for the services
  def json_load(string)
    Oj.load(string)
  rescue Oj::ParseError
    string
  end
end
