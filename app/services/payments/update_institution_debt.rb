module Payments
  class UpdateInstitutionDebt

    def update_all
      Services::Institution.all.each do |institution|
        institution.update(total_debt: institution.calculated_total_debt)
      end
    end
  end
end