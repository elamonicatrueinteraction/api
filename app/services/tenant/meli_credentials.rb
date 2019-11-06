module Tenant
  class MeliCredentials

    attr_reader :credentials

    def initialize
      @credentials = credentials
    end

    def credentials_for(network:)
      if network.to_sym == :ROS
        @credentials['BAR']
      elsif network.to_sym == :MCBA || network.to_sym == :LP
        @credentials[:NILUS]
      else
        @credentials[network]
      end
    end

    def lacks_tokens_of
      result = {}
      tokens = credentials
      tokens.keys.each do |tenant|
        missing_credentials = lacking_tokens_for(tokens, tenant)
        result[tenant] = missing_credentials if missing_credentials.any?
      end
      result
    end

    def lacking_tokens_for(tokens, tenant)
      tokens[tenant].keys.select { |y| tokens[tenant][y].blank? }
    end

    def credentials
      {
        BAR: {
          public_key: Rails.application.secrets.mercadopago_bar_public_key,
          access_token: Rails.application.secrets.mercadopago_bar_access_token,
          payee_name: Rails.application.secrets.mercadopago_bar_payee_name,
          email: Rails.application.secrets.mercadopago_payer_email_bar
        },
        MDQ: {
          public_key: Rails.application.secrets.mercadopago_mdq_public_key,
          access_token: Rails.application.secrets.mercadopago_mdq_access_token,
          payee_name: Rails.application.secrets.mercadopago_mdq_payee_name,
          email: Rails.application.secrets.mercadopago_payer_email_mdq
        },
        NILUS: {
          public_key: Rails.application.secrets.mercadopago_nilus_public_key,
          access_token: Rails.application.secrets.mercadopago_nilus_access_token,
          payee_name: Rails.application.secrets.mercadopago_nilus_payee_name,
          email: Rails.application.secrets.mercadopago_payer_email_nilus
        }
      }.with_indifferent_access
    end
  end
end
