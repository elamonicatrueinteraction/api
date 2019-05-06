module Gateway
  module Mercadopago
    module PaymentMercadopagoSync
      class FakeMercadopagoPaymentCheck
        prepend Service::Base

        def initialize(payment, type)
          @payment = payment
          @state = "not found"

          if type == 0
            @state = "approved"
          else
            if type == 1
              @state = "cancelled"
            else
              if type == 2
                @state = "in progress"
              else
                if type == 3
                  @state == "not found"
                end
              end
            end
          end
        end

        def call
          get_payment_mercadopago
        end

        private

        def get_payment_mercadopago
          if @state == "not found"
            response_not_found = {
                message: "Payment not found",
                error: "not_found",
                status: 404,
                cause: [{code: 2000, description: "Payment not found", data: nil}]
            }

            response_not_found
          else
            data = @payment.gateway_data
            data['status'] = @state
            data['status_detail'] = "State_#{@state}"

            if @state == "approved"
              data['date_approved'] = Time.zone.now if @state == "approved"
            end

            data
          end

        end
      end
    end
  end
end