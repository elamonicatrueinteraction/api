module Reports
  class RemotePaymentReport

    def make_csv(payments)
      CSV.generate(headers: true) do |csv|
        csv << headers

        payments.each do |payment|
          csv << make_row(payment)
        end
      end
    end

    private

    def headers
      ['Fecha', 'Tipo de Operación', 'Código de Operación',
       'Código de Comedor', 'Nombre de Comedor', 'Identificador externo', 'Proveedor', 'Area']
    end

    def make_row(payment)
      receiver = payment.payable&.receiver
      operation_type = payment.payable ? operation_type(payment) : "Desvinculado"
      external_reference = receiver ? receiver.external_reference : "Desvinculado"
      operation_id = payment.payable ? payment.payable.id : "Desvinculado"
      name = receiver ? receiver.name : "Desvinculado"
      [payment.created_at, operation_type, operation_id, external_reference,
      name, payment.gateway_id, payment.gateway, payment.network_id]
    end

    def operation_type(payment)
      payment.payable.is_a?(Order) ? "Orden" : "Delivery"
    end
  end
end