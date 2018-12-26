class UpdateTotalDebtWorker
  include Sidekiq::Worker

  def perform(payment_id)
    @payment_id = payment_id
    Rails.logger.info "About to update #{payment.payer_institution_id} total debt"
  end

  private

  def payment
    @payment ||= Payment.find(payment_id)
  end
end
