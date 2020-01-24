module Gateway
  class PaymentGateway
    def self.account_for(payable, gateway_name = 'mercadopago')
      new(payable, gateway_name).send(:account)
    end

    private

    ACCOUNT_CLASS_FOR_GATEWAY = {
      'mercadopago' => Gateway::Mercadopago::MercadopagoClient
    }.freeze
    private_constant :ACCOUNT_CLASS_FOR_GATEWAY

    def initialize(payable, gateway_name)
      @credentials = get_credentials_for(payable).symbolize_keys
      @gateway_account_class = ACCOUNT_CLASS_FOR_GATEWAY.fetch(gateway_name)
      self
    end

    def account
      @gateway_account_class.new(@credentials[:access_token])
    end

    def get_credentials_for(payable)
      return {
        public_key: Rails.application.secrets.mercadopago_nilus_public_key,
        access_token: Rails.application.secrets.mercadopago_nilus_access_token
      } if payable.type == Delivery.name

      # TODO: Move this to a database record
      meli_tokens = Tenant::MeliCredentials.new
      meli_tokens.credentials_for(network: payable.network_id)
    end

  end
end