class UpdateTotalDebtWorker
  include Sidekiq::Worker

  def perform(payment_id)
    @payment_id = payment_id
    Rails.logger.info "About to update #{institution.id} total debt"
    Rails.logger.info "Calculated debt is #{institution.calculated_total_debt}"
    institution.update(
      total_debt: institution.calculated_total_debt
    )
    Rails.logger.info "Updated debt"
  end

  private

  def institution
    @institution ||= Services::Institution.find(payment.payer_institution_id)
  end

  def payment
    @payment ||= Payment.find(@payment_id)
  end
end
