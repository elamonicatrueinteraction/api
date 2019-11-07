module Gateway
  class PaymentSync

    def initialize(gateway_provider: PaymentGateway)
      @gateway_provider = gateway_provider
      @amount_of_coupons_processed = 0
      @amount_of_remote_errors = 0
      @amount_of_coupon_errors = 0
    end

    def sync_payments
      Rails.logger.info 'Request all pending payments'

      pending_payments = Payments::PendingPayments.call.result

      #TODO: devolver los ID o Institution vinculadas con la actualización del estado de cupones, a fin de sincronizar el total_debt de cada una de ellas - EZE
      pending_payments.each(&method(:gateway_check))

      Rails.logger.info "Coupon sync finished. Coupons processed: #{@amount_of_coupons_processed}," \
            "Remote errors: #{@amount_of_remote_errors}, Other errors: #{@amount_of_coupon_errors}"
    end

    def gateway_check(payment)
      Rails.logger.info "Request to mercadopago about a payment with id: #{payment.id} and gateway_id: #{payment.gateway_id}"
      begin
        client = @gateway_provider.account_for(payment.payable)
        gateway_data = client.payment(payment.gateway_id)
      rescue StandardError => e
        Rails.logger.info "Remote Error: #{e}"
        @amount_of_remote_errors += 1
        return
      end
      begin
        status = gateway_data.status
        if payment.status != status
          payment = update_payment(payment, gateway_data)
          payment.save!
        end
        @amount_of_coupons_processed += 1
        Rails.logger.info "[PaymentMercadopagoSync] - Processed #{@amount_of_coupons_processed}" if @amount_of_coupons_processed % 100 == 0
      rescue StandardError => e
        Rails.logger.info "My error: #{e}"
        @amount_of_coupon_errors += 1
        return
      end
    end

    def update_payment(payment, mercadopago_data)
      payment = UpdatePayment.call(payment, mercadopago_data).result
      payment
    end
  end
end
