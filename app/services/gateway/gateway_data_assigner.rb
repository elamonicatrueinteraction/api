module Gateway
    class GatewayDataAssigner
      
      def assign(payment, data)
        gateway_id = data.payment_id
        gateway_status = data.status
        payment_status = data.status == "400" ? Payment::Types::PENDING : gateway_status
        payment.status = payment_status
        payment.gateway = data.gateway
        payment.gateway_id = gateway_id
        payment.gateway_data = data.raw_data
        payment
      end
    end
end