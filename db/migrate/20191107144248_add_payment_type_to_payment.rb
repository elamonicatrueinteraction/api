class AddPaymentTypeToPayment < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :payment_method, :string
  end
end
