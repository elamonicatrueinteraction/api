module MeliHelpers
  def self.mercadopago_test_credentials?(client_id, client_secret)
    client_secret.include?('TEST') && client_id.include?('TEST')
  end
end
