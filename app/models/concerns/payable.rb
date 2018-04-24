module Payable
  extend ActiveSupport::Concern

  included do
    has_many :payments, as: :payable, dependent: :destroy
  end

  def active_payments
    @active_payments ||= payments.select do |_payment|
      _payment.approved? || _payment.pending? || _payment.in_process?
    end
  end

  def has_active_payments?
    active_payments.present?
  end
end
