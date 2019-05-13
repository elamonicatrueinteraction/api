module Gateway
  class PaymentsCheckWorker
    include Sidekiq::Worker

    def perform(*args)
      p 'The process started'
      logger.info 'The process started'

      Gateway::Mercadopago::PaymentMercadopagoSync::PaymentsCheck.call

      p 'The proccess ended'
      logger.info 'The proccess ended'
    end
  end
end