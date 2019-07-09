class AddOldUserToWallet < ActiveRecord::Migration[5.1]
  def change
    add_reference :wallets, :old_user, foreign_key: true
  end
end
