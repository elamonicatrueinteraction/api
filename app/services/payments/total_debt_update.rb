module Payments
  class TotalDebtUpdate

    def initialize(debt_calculator: TotalDebt.new)
      @debt_calculator = debt_calculator
    end

    def update_debt_for(institution:)
      debt = @debt_calculator.calculate(institution)
      institution.update({total_debt: debt})
    end
  end
end