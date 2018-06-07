module ShipperApi
  class AuthenticateShipper
    prepend Service::Base

    def initialize(email, password, device = {}, ip = nil)
      @email = email
      @password = password
      @expiration = 24.hours.from_now.to_i
      @ip = ip
      @device = begin
        return {} unless device

        device = HashWithIndifferentAccess.new(device).deep_symbolize_keys
        type, token = device.fetch_values(:type, :token)

        return {} if token.blank?

        {
          type: type,
          token: token
        }
      rescue KeyError => e
        {}
      end
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
      }.tap do |_columns|
        if @device.present? && !@shipper.has_device?(@device)
          _columns[:devices] = shipper_devices
          AddShipperToQueueWorker.perform_in(10.seconds, @shipper.id)
        end
      end
    end

    # TO-DO: We should remove this logic from here
    def shipper_devices
      devices_hash = (@shipper.devices || {}).symbolize_keys

      type, token = @device.fetch_values(:type, :token)
      type = type.to_sym

      devices_hash[type] = devices_hash[type] || {}
      devices_hash[type][token] = Time.current.to_s

      devices_hash
    end

  end
end
