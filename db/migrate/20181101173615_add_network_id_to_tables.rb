class AddNetworkIdToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :network_id, :string
    add_index :orders, :network_id
  end
end
