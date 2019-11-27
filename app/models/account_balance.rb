# == Schema Information
#
# Table name: account_balances
#
#  id             :uuid             not null, primary key
#  institution_id :uuid
#  amount         :decimal(12, 4)   default(0.0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class AccountBalance < ApplicationRecord

  attr_accessor :institution

  def institution
    @institution ||= Services::Institution.find(institution_id)
  end

  def calculate_debt_amount_of_institution(institution_id)
    orders = Order.by_receiver_id(institution_id).includes(:payments, deliveries: [:payments])
    outside_transactions = UntrackedActivity.by_institution_id(institution_id).includes(:payments)
    transaction_payments = outside_transactions.map(&:payments)
                             .flatten
                             .pluck(:status, :amount)
    order_payments = orders.map(&:payments)
                       .flatten
                       .pluck(:status, :amount)
    delivery_payments = orders.map {|x| x.deliveries.map(&:payments)}
                          .flatten
                          .pluck(:status, :amount)
    total_payments = order_payments + delivery_payments + transaction_payments
    total_payments.select {|x| x[0] == Payment::Types::PENDING}.map {|x| x[1]}.sum
  end

  def self.amount_of(institution_id)
    account = self.find_by institution_id: institution_id
    return 0 if account.nil?

    account.amount
  end

  def update_debt_amount!
    self.amount = calculate_debt_amount_of_institution(self.institution_id)
    self.save!
  end

  def self.update_balance(institution_id)
    accountBalance = self.find_or_create_by! institution_id: institution_id
    accountBalance.amount = accountBalance.calculate_debt_amount_of_institution institution_id
    accountBalance.save!
  end

end
