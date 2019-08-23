module Payments
  class TotalDebt

    def calculate(institution)
      orders = Order.by_receiver_id(institution.id).includes(:payments, deliveries: [:payments])
      order_payments = orders.map(&:payments)
                             .flatten
                             .pluck(:status, :amount)
      delivery_payments = orders.map { |x| x.deliveries.map(&:payments) }
                                .flatten
                                .pluck(:status, :amount)
      total_payments = order_payments + delivery_payments
      total_payments.select { |x| x[0] == Payment::Types::PENDING }.map { |x| x[1] }.sum
    end
  end
end
