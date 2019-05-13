module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class UpdatePayment
        prepend Service::Base

        def initialize(payment, mercadopago_data)
          @payment = payment
          @mercadopago_data = mercadopago_data
        end

        def call
          update
        end

        private

        def update
          state = @mercadopago_data[:status] || @mercadopago_data["status"]
          if state != "pending"
            if state == "approved"
              approved
            else
              if state == "cancelled"
                update_status(state)
              else
                false
              end
            end
          else
            false
          end
        end

        def approved
          transactions_details = @mercadopago_data[:transaction_details] || @mercadopago_data["transaction_details"]
          collected_amount = transactions_details[:total_paid_amount] || transactions_details["total_paid_amount"] #monto pagado por el comprador(incluye comisiones)
          date_approved = @mercadopago_data[:date_approved] || @mercadopago_data["date_approved"] || Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z') #fecha que se aprobo el pago
          @payment.collected_amount = collected_amount
          @payment.paid_at = date_approved
          @payment.gateway_data = @mercadopago_data
          @payment.status = "approved"

          Sidekiq::logger.info "The payment was approved for the amount of #{collected_amount}"

          update_total_debt if @payment.save
        end

        def update_status(status)
          Sidekiq::logger.info "The payment was #{status}"
          @payment.status = status
          @payment.save
        end

        def update_total_debt
          institution ||= Services::Institution.find(@payment.payer_institution_id)
          if institution.nil?
            Rails.logger.info "Payment #{@payment.id} has #{@payment.payer_institution_id}, it does not exist"
            return false
          end
          institution.total_debt = institution.calculated_total_debt

          Sidekiq::logger.info "total_debt = #{institution.total_debt}"

          if institution.save
            true
          else
            false
          end
        end
      end
    end
  end
end