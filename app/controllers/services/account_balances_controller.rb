module Services
  class AccountBalancesController < BaseController

    def show
      id = params[:id]
      account = AccountBalance.find_by(institution_id: id)
      render json: account
    end

    def index
      render json: AccountBalance.all
    end
  end
end
