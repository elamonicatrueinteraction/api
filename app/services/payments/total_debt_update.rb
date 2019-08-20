module Payments
  class TotalDebtUpdate

    def initialize(debt_calculator: TotalDebt.new)
      @debt_calculator = TotalDebt.new
    end

    def update_debt_for(institution:)
      debt = @debt_calculator.calculate(institution)
      institution.total_debt = debt
      institution.save
    end
  end
end