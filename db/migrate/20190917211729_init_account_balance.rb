class InitAccountBalance < ActiveRecord::Migration[5.1]
  def change
    Order.all.pluck(:receiver_id).uniq.each do |institution_id|
      AccountBalance.update_balance(institution_id)
    end
  end
end
