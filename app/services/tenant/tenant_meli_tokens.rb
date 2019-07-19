module Tenant
  class TenantMeliTokens

    def initialize
      @tokens = secret_tokens
    end

    def tokens(network)
      if network == 'ROS'
        @tokens['BAR']
      else
        @tokens[network]
      end
    end

    private

    def secret_tokens
      {
        BAR: {
          public_key: Rails.application.secrets.mercadopago_bar_public_key,
          access_token: Rails.application.secrets.mercadopago_bar_access_token
        },
        MDQ: {
          public_key: Rails.application.secrets.mercadopago_mdq_public_key,
          access_token: Rails.application.secrets.mercadopago_mdq_access_token
        }
      }.with_indifferent_access
    end
  end
end