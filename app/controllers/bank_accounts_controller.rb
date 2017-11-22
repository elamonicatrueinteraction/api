class BankAccountsController < ApplicationController

  # GET /bank_accounts
  def index
    bank_accounts = BankAccount.all
    render json: { bank_accounts: bank_accounts }, status: :ok # 200
  end

  # GET /bank_accounts/:id
  def show
    set_bank_account
    render json: { bank_account: @bank_account }, status: :ok # 200
  end

  # POST /bank_accounts
  def create
    bank_account = BankAccount.create(bank_account_params)

    if bank_account.valid?
      render json: { bank_account: bank_account }, status: :created # 201
    else
      render json: { error: bank_account.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  # PATCH /bank_accounts/:id
  def update
    set_bank_account
    if bank_account = @bank_account
      bank_account.update(bank_account_params)

      if bank_account.valid?
        render json: { bank_account: bank_account }, status: :ok # 200
      else
        render json: { bank_account: bank_account }, status: :unprocessable_entity # 422
      end

    else
      render json: { error: "Not found" }, status: :not_found # 404
    end
  end

  private

  def bank_account_params
    params.permit(
      :bank_name,
      :number,
      :type,
      :cbu,
      :shipper_id
    )
  end

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end
end