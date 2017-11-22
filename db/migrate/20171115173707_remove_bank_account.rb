class RemoveBankAccount < ActiveRecord::Migration[5.1]
  def change
    remove_index :shippers, :bank_account
    remove_column :shippers, :bank_account, :jsonb, null: true, default: {}
  end
end
