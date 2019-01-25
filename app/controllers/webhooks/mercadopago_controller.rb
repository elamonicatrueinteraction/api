module Webhooks
  class MercadopagoController < BaseController
    log_notification :payment_notification

    def payment_notification
      key_for_webhook = "webhooks:mercadopago:#{payment_id}-payment"

      if $redis.setnx(key_for_webhook, true)
        if payment = Payment.find_by(gateway: 'Mercadopago', id: payment_id)
          service = ::Gateway::Mercadopago::Webhooks::UpdatePayment.call(payment, mercadopago_id, notification_body)

          unless service.success?
            Rollbar.info("Payment unsuccessful #{payment}", not_body: notification_body, par: params)
            render json: nil, status: :unprocessable_entity and return
          end
        end
      end

      render json: nil, status: :ok # 200
    ensure
      $redis.del(key_for_webhook)
    end

    private

    def payment_id
      @payment_id ||= allowed_params[:uuid]
    end

    def mercadopago_id
      @mercadopago_id ||= allowed_params[:data] ? allowed_params[:data][:id] : allowed_params[:id]
    end

    def data
      allowed_params[:data]
    end

    def notification_body
      allowed_params[:mercadopago] || {}
    end

    def allowed_params
      @allowed_params ||= params.permit(
        :uuid,
        :id,
        :topic,
        mercadopago: {},
        data: {}
      )
    end

  end
end
