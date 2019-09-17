class AccountBalance < ApplicationRecord


  attr_accessor :institution

  def institution
    @institution ||= Services::Institution.find(institution_id)
  end

  def self.amount_of(institution_id)
    account = self.find_by institution_id: institution_id
    return 0 if account.nil?

    account.amount
  end

end
