class CreateBankAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_index :shippers, :bank_account
    remove_column :shippers, :bank_account

    create_table :bank_accounts, id: :uuid do |t|
      t.string :bank_name
      t.string :number
      t.string :type
      t.string :cbu
      t.references :shipper, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
