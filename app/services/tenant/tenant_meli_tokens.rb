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

    def lacks_tokens_of
      result = {}
      tokens = secret_tokens
      tokens.keys.each do |tenant|
        missing_credentials = lacking_tokens_for(tokens, tenant)
        result[tenant] = missing_credentials if missing_credentials.any?
      end
      result
    end

    def lacking_tokens_for(tokens, tenant)
      tokens[tenant].keys.select { |y| tokens[tenant][y].blank? }
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
        },
        MCBA: {
          public_key: Rails.application.secrets.mercadopago_mcba_public_key,
          access_token: Rails.application.secrets.mercadopago_mcba_access_token
        },
        LP: {
          public_key: Rails.application.secrets.mercadopago_lp_public_key,
          access_token: Rails.application.secrets.mercadopago_lp_access_token
        }
      }.with_indifferent_access
    end
  end
end
