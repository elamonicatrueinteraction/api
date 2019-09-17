module Payments
  class UpdateInstitutionDebt

    def update_all
      Services::Institution.all.each do |institution|
        TotalDebtUpdate.new.update_debt_for(institution)
      end
    end
  end
end