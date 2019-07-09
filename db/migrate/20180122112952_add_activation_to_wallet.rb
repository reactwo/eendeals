class AddActivationToWallet < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :activation, :decimal, scale: 4, precision: 10, default: 0
  end
end
