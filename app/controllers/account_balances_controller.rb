class AccountBalancesController < ApplicationController

  def index
    institutions = Services::Institution.where(network_id: current_network)
    institution_ids = institutions.map(&:id)
    account_balances = AccountBalance.where(institution_id: institution_ids)

    render json: account_balances, status: :ok
  end

end
