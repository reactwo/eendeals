class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.decimal :active, precision: 10, scale: 4
      t.decimal :passive, precision: 10, scale: 4
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
