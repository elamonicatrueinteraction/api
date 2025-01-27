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

    def lack_emails_of
      emails = secret_emails
      emails.keys.select { |x| emails[x].blank? }
    end

    private

    def secret_emails
      {
        BAR: Rails.application.secrets.mercadopago_payer_email_bar,
        MDQ: Rails.application.secrets.mercadopago_payer_email_mdq,
        MCBA: Rails.application.secrets.mercadopago_payer_email_mcba,
        LP: Rails.application.secrets.mercadopago_payer_email_lp
      }.with_indifferent_access
    end
  end
end