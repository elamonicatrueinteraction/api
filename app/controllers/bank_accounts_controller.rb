class BankAccountsController < ApplicationController
  include CurrentAndEnsureDependencyLoader

  def index
    ensure_shipper; return if performed?

    bank_accounts = current_shipper.bank_accounts

    paginated_results = paginate(bank_accounts)
    render json: paginated_results, status: :ok # 200
  end

  def show
    optional_shipper; return if performed?

    if bank_account = get_bank_account
      render json: bank_account, status: :ok # 200
    else
      render json: { errors: "Not found" }, status: :not_found # 404
    end
  end

  def create
    ensure_shipper; return if performed?

    bank_account = current_shipper.bank_accounts.new( bank_account_params )

    if bank_account.save
      render json: bank_account, status: :created # 201
    else
      render json: { errors: bank_account.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  def update
    optional_shipper; return if performed?

    if bank_account = get_bank_account
      bank_account.update( bank_account_params )
      if bank_account.valid?
        render json: bank_account, status: :ok # 200
      else
        render json: { errors: bank_account.errors.full_messages }, status: :unprocessable_entity # 422
      end
    else
      render json: { errors: [ I18n.t("errors.not_found.bank_account", id: params[:id]) ] }, status: :not_found # 404
    end
  end

  private

  def bank_account_params
    params.permit(
      :bank_name,
      :number,
      :type,
      :cbu
    )
  end

  def get_bank_account
    if current_shipper
      current_shipper.bank_accounts.find_by(id: params[:id])
    else
      BankAccount.find_by(id: params[:id])
    end
  end
end
