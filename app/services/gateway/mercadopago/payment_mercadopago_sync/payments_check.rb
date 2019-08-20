module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class PaymentsCheck
        prepend Service::Base

        def call
          check
        end

        private

        def check
          @amount_of_coupons_processed = 0
          @amount_of_meli_errors = 0
          @amount_of_coupon_errors = 0
          Rails.logger.info 'Request all pending payments'

          pending_payments = Gateway::Mercadopago::PaymentMercadopagoSync::PendingPayments.call.result

          pending_payments.each(&method(:mercadopago_check))
          Rails.logger.info "Coupon sync finished. Coupons processed: #{@amount_of_coupons_processed},
            Meli errors: #{@amount_of_meli_errors}, Other errors: #{@amount_of_coupon_errors}"
        end

        def mercadopago_check(payment)
          Rails.logger.info "Request to mercadopago about a payment with id: #{payment.id} and gateway_id: #{payment.gateway_id}"
          status = nil
          begin
            mercadopago_data = Gateway::Mercadopago::PaymentMercadopagoSync::MercadopagoPaymentCheck.call(payment).result
            status = mercadopago_data["status"]
          rescue StandardError => e
            Rails.logger.info "MercadoPago Error: #{e}"
            @amount_of_meli_errors += 1
          end
          Rails.logger.info "Response mercadopago status: #{status}"
          if !status.nil?
            update_payment(payment, mercadopago_data) if payment.status != status
          else
            notify(payment)
          end
          @amount_of_coupons_processed += 1
          Rails.logger.info "[PaymentMercadopagoSync] - Processed #{@amount_of_coupons_processed}" if @amount_of_coupons_processed % 100 == 0
        end

        def update_payment(payment, mercadopago_data)
          Rails.logger.info 'In update payment'

          result = Gateway::Mercadopago::PaymentMercadopagoSync::UpdatePayment.call(payment, mercadopago_data)

          Rails.logger.info "Result update: #{result.result}"
        end

        def notify(payment)
          #TODO: Deberia de notificar que no existe este payment en mercadopago
        end

      end
    end
  end
end
