module ShipperApi
  class AuthenticateShipper
    prepend Service::Base

    def initialize(email, password, ip = nil)
      @email = email
      @password = password
      @expiration = 24.hours.from_now.to_i
      @ip = ip
    end

    def call
      JsonWebToken.encode({ shipper_id: shipper.id }, @expiration) if shipper
    end

    private

    attr_accessor :email, :password

    def shipper
      return @shipper unless @shipper.blank?

      @shipper = Shipper.find_by(email: email)
      if @shipper && @shipper.authenticate(password)
        @shipper.update( columns_to_update )
        return @shipper
      end

      @shipper.update(failed_login_count: (@shipper.failed_login_count + 1) ) if @shipper

      errors.add(:user_authentication, I18n.t('services.api.authenticate.invalid_credentials')) && nil
    end

    def columns_to_update
      {
        token_expire_at: @expiration,
        login_count: (@shipper.login_count + 1),
        last_login_at: Time.now,
        last_login_ip: @ip
      }
    end

  end
end
