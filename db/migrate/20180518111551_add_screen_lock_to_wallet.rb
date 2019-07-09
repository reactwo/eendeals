class AddScreenLockToWallet < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :screen_lock, :decimal, precision: 10, scale: 4, default: 0
  end
end
