class AddAmountToOffer < ActiveRecord::Migration[5.1]
  def change
    add_column :offers, :amount, :decimal, scale: 4, precision: 10
  end
end
