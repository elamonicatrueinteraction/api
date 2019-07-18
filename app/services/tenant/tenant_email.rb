module Tenant
  class TenantEmail

    def initialize
      @emails = secret_emails
    end

    def email(network)
      if network == 'ROS'
        @emails['BAR']
      else
        @emails[network]
      end
    end

    private

    def secret_emails
      {
        BAR: Rails.application.secrets.mercadopago_payer_email_bar,
        MDQ: Rails.application.secrets.mercadopago_payer_email_mdq
      }.with_indifferent_access
    end
  end
end