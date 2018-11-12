class AuthenticateUser
  prepend Service::Base

  def initialize(email, password, ip = nil)
    @email = email
    @password = password
    @expiration = 2.months.from_now.to_i
    @ip = ip
  end

  def call
    JsonWebToken.encode({ user_id: user.id }, @expiration) if user
  end

  private

  attr_accessor :email, :password

  def user
    return @user unless @user.blank?

    @user = User.find_by(email: email)
    if @user && @user.authenticate(password)
      @user.update( columns_to_update )
      return @user
    end

    @user.update(failed_login_count: (@user.failed_login_count + 1) ) if @user

    errors.add(:user_authentication, I18n.t('services.authenticate.invalid_credentials')) && nil
  end

  def columns_to_update
    {
      token_expire_at: @expiration,
      login_count: (@user.login_count + 1),
      last_login_at: Time.now,
      last_login_ip: @ip
    }
  end

end
