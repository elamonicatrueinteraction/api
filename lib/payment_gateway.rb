class PaymentGateway

  def self.account_for(payable, gateway_name = 'mercadopago')
    new(payable, gateway_name).send(:account)
  end

  private

  ACCOUNT_CLASS_FOR_GATEWAY = {
    'mercadopago' => ::MercadoPago::CustomCheckout::Account
  }.freeze
  private_constant :ACCOUNT_CLASS_FOR_GATEWAY

  def initialize(payable, gateway_name)
    @credentials = get_credentials_for(payable).symbolize_keys
    @gateway_account_class = ACCOUNT_CLASS_FOR_GATEWAY.fetch(gateway_name)
    self
  end

  def account
    @gateway_account_class.new(@credentials)
  end

  private

  def get_credentials_for(payable)
    payable.is_a?(Order) ? MERCADOPAGO['bar'] : MERCADOPAGO['nilus']
  end

end

# For MERCADOPAGO

# Grab the credentials via this link:
# https://www.mercadopago.com/mla/account/credentials

# MercadoPago AR Test Users (https://www.mercadopago.com.ar/developers/en/related/test-users/)
#  - {"id":316516415,"nickname":"TETE7989260","password":"qatest526","site_status":"active","email":"test_user_92696780@testuser.com"}
#  - {"id":316519508,"nickname":"TETE6135026","password":"qatest3495","site_status":"active","email":"test_user_29747195@testuser.com"}
#  - {"id":316534448,"nickname":"TETE6564819","password":"qatest7313","site_status":"active","email":"test_user_92173722@testuser.com"}