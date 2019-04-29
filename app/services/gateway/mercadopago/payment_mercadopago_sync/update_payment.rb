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
          state = @mercadopago_data["status"]
          if state != "pending"
            if state == "approved"
              approved
            end
          else
            @payment
          end
        end

        def approved
          collected_amount = @mercadopago_data["transaction_details"]["total_paid_amount"] #monto pagado por el comprador(incluye comisiones)
          date_approved = @mercadopago_data["date_approved"] || Time.zone.now #fecha que se aprobo el pago
          @payment.collected_amount = collected_amount
          @payment.paid_at = Time.at(date_approved)
          @payment.gateway_data = @mercadopago_data
          @payment.status = "approved"

          if @payment.save
            update_total_debt
          end
        end

        def update_total_debt
          institution ||= Services::Institution.find(@payment.payer_institution_id)
          if institution.nil?
            Rails.logger.info "Payment #{@payment.id} has ##{@payment.payer_institution_id}, it does not exist"
            return
          end
          institution.total_debt = institution.calculated_total_debt
          institution.save
        end
      end
    end
  end
end