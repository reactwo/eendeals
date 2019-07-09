class AddTotalToWallet < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :total_earning, :decimal, precision: 10, scale: 4, default: 0
    add_column :wallets, :total_redeem, :decimal, precision: 10, scale: 4, default: 0
  end
end
