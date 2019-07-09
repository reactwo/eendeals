class AddRedeemToWallet < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :redeem, :decimal, precision: 10, scale: 4, default: 0
  end
end
