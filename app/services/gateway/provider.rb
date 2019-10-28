module Gateway
  class Provider

    def gateway_for(service:, payee_code:)
      gateway_supplier = gateways[service]
      if gateway_supplier.nil?
        raise StandardError.new("No se encontró gateway de pagos para el servicio #{service}")
      end
      gateway_supplier.call(payee_code: payee_code)
    end

    def gateways
      {
        Mercadopago: -> (payee_code: ) { Mercadopago::MercadopagoGateway.new(payee_code: payee_code)}
      }.with_indifferent_access
    end
  end
end