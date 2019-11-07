module Gateway
  class RemoteNotFoundPaymentSync

    def initialize
      @tokens = Tenant::MeliCredentials.new
      @amount_of_coupons_processed = 0
    end

    def sync_payments
      Rails.logger.info 'Request all payments with not found remote'

      pending_payments = RemoteNotFoundQuery.call.result
      pending_payments.each(&method(:gateway_check))

      Rails.logger.info "Remote not found Coupon sync finished. Coupons processed: #{@amount_of_coupons_processed}"
    end

    def gateway_check(payment)
      Rails.logger.info "Request to mercadopago for payment with id: #{payment.id} and gateway_id: #{payment.gateway_id}"
      begin
        tokens = @tokens.credentials
        gateway_data = nil
        tokens.each_key do |owner|
          Rails.logger.info "Trying #{owner} mercadopago secrets"
          client = Gateway::Mercadopago::MercadopagoClient.new(tokens[owner][:access_token])
          gateway_data = client.payment(payment.gateway_id)
          if gateway_data.status != "404"
            Rails.logger.info "Found owner! #{owner}"
            break
          end
        end
        status = gateway_data ? gateway_data.status : Payment::Types::PENDING
        if payment.status != status
          payment = update_payment(payment, gateway_data)
          payment.save!
        end
        @amount_of_coupons_processed += 1
        Rails.logger.info "[PaymentMercadopagoSync] - Processed #{@amount_of_coupons_processed}" if @amount_of_coupons_processed % 100 == 0
      end
    end

    def update_payment(payment, mercadopago_data)
      payment = UpdatePayment.call(payment, mercadopago_data).result
    end
  end
end