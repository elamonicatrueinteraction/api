class JsonWebToken
  class << self

    def encode(payload, exp = 24.hours.from_now.to_i)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base, ALGORITHM)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: ALGORITHM })[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end

    private

    ALGORITHM = 'HS512'.freeze
  end
end
