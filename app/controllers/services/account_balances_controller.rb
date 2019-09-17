module Services
  class AccountBalancesController < BaseController

    def all
      render json: AccountBalance.all, adapter: :attributes
    end

    def by_institution
      account = AccountBalance.find_by institution_id: institution_id
      render json: account, adapter: :attributes
    end


    private

    def full_params
      account_balance_params.tap do |_params|
        _params[:institution_id] = institution_id
        _params[:network_id] = request.headers['X-Network-Id']
      end
    end

    def plain_hash_params
      @plain_params ||= params.to_unsafe_hash
    end

    def account_balance_params
      params.require(:account_balances).permit(
        :institution_id
      ).to_unsafe_hash
    end

    def institution_id
      plain_hash_params.dig(:account_balances, :institution_id)
    end
  end
end
